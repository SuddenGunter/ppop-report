defmodule Reporter do
  use HTTPoison.Base

  def build(cfg) do
    {donations, spent} = fetch(cfg) |> process(cfg)
    header(donations, spent) |> print_header()
    donations |> tablify |> print_table()
    spent |> tablify |> print_table()
  end

  defp fetch(cfg) do
    headers = ["X-Token": "#{cfg[:ApiKey]}"]

    case HTTPoison.get!(
           cfg[:ApiUrl] <> "/personal/statement/#{cfg[:AccountID]}/#{cfg[:From]}/#{cfg[:To]}",
           headers
         ) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body |> Poison.decode!(as: [%Transaction{}])

      %HTTPoison.Response{status_code: code, body: body} ->
        IO.puts("api call failed with code: #{code}, error: #{body}")
        []
    end
  end

  defp process(transactions, cfg) do
    ignored = cfg[:Ignored]

    IO.puts("received #{Enum.count(transactions)} transactions")

    transactions
    |> Enum.filter(fn x -> ignore?(ignored, x.description) end)
    |> Enum.map(fn x -> Map.put(x, :amount, x.amount / 100) end)
    |> Enum.sort_by(fn x -> x.time end)

    donations = Enum.filter(transactions, fn x -> x.amount >= 0 end)
    spent = Enum.filter(transactions, fn x -> x.amount < 0 end)

    {donations, spent}
  end

  defp tablify(transactions) do
    transactions
    |> Enum.flat_map(fn x ->
      cond do
        x.comment == nil ->
          [
            "| #{format_date(DateTime.from_unix!(x.time))} | #{x.amount} UAH   | #{x.description} |"
          ]

        String.length(x.comment) >= 45 ->
          [
            "| #{format_date(DateTime.from_unix!(x.time))} | #{x.amount} UAH   | #{x.comment} |",
            "|    |     | #{x.description} |"
          ]

        true ->
          [
            "| #{format_date(DateTime.from_unix!(x.time))} | #{x.amount} UAH   | #{x.comment}, #{x.description} |"
          ]
      end
    end)
  end

  defp ignore?(ignored, description) do
    false
  end

  defp print_table(table) do
    IO.puts("| Дата | Сума | Комент/Відправник |")
    IO.puts("| ---- | ----- | ----- |")
    table |> Enum.map(fn x -> IO.puts(x) end)
  end

  defp print_header({d, s}) do
    diff = abs(d) - abs(s)
    IO.puts("total donations: #{d}, total spent: #{s}, total balance: #{diff}")
  end

  defp header(donations, spent) do
    sumD = donations |> Enum.map(fn x -> x.amount end) |> Enum.sum()
    sumS = spent |> Enum.map(fn x -> x.amount end) |> Enum.sum()
    {sumD, sumS}
  end

  defp format_date(date) do
    {{y, m, d}, _} = NaiveDateTime.to_erl(DateTime.to_naive(date))
    day = String.pad_leading(Integer.to_string(d), 2, "0")
    month = String.pad_leading(Integer.to_string(m), 2, "0")
    "#{day}/#{month}/#{y}"
  end
end

defmodule Reporter do
  use HTTPoison.Base

  def build(cfg) do
    transactions = fetch(cfg)
    process(transactions, cfg) |> IO.puts()
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
    Enum.filter(transactions, fn x -> shouldBeIgnored(ignored, x[:Description]) end)
    0
  end

  defp shouldBeIgnored(ignored, description) do
    true
  end
end

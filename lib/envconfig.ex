defmodule EnvConfig do
  def build() do
    cfg = Application.get_env(:ppop_report, Report)
    validate(cfg)
  end

  def mock() do
    %{
      ApiUrl: "http://localhost:8080",
      ApiKey: "key",
      From: "from",
      To: "to",
      Ignored: ["ignored"]
    }
  end

  defp validate(cfg) do
    IO.inspect(cfg, label: "config")

    {
      :valid,
      cfg
    }
  end
end

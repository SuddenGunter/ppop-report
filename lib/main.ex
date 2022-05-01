defmodule Report.CLI do
  def main(_args) do
    case EnvConfig.build() do
      {:valid, cfg} -> Reporter.build(cfg)
      {:error, reason} -> IO.puts(reason)
    end
  end
end

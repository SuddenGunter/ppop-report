import Config

config :ppop_report, Report,
  ApiUrl: "",
  ApiKey: "",
  From: "",
  To: "",
  Ignored: [""]

import_config "#{config_env()}.exs"

import Config

config :ppop_report, Report,
  ApiUrl: "",
  ApiKey: "",
  AccountID: "",
  From: "",
  To: "",
  Ignored: [""]

import_config "#{config_env()}.exs"

import Config

config :ppop_report, Report,
  ApiUrl: "",
  ApiKey: "",
  AccountID: "",
  From: "",
  To: "",
  IgnoredDescriptions: [],
  AlwaysAllowedIDs: []

import_config "#{config_env()}.exs"

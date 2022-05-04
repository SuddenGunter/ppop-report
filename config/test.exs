import Config

config :ppop_report, Report,
  ApiUrl: "https://api.monobank.ua",
  ApiKey: "",
  AccountID: "",
  From: "1649750400",
  To: "1651006800",
  IgnoredDescriptions: ["З білої картки"],
  AlwaysAllowedIDs: []

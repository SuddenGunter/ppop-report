# ppop-report

This is a report generator for  <https://github.com/SuddenGunter/ppop-funds> project - a static website build with Hugo for fundraising I've done during war in Ukraine for Kharkiv special purpose police regiment.

Website is hosted at: <https://fund.suddengunter.com/> and served via CloudFlare Pages.

I used my personal bank account to gather donations, so I needed a way to differentiate my transactions (and deposits to cover them) from fund. Reporting was done manualy during the fundraising, but I've wrote some short elixir app to do it post-factum (found a few errors in old manual report).

## How to run

Put your settings into `config/dev.exs` and run `mix escript.build && ./ppop_report`.

[
  import_deps: [:phoenix],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "priv/*/samples.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}"
  ]
]

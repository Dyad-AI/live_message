defmodule LiveMessage.MixProject do
  use Mix.Project

  @description """
  Unified messaging for LiveViews and LiveComponents
  """

  @version "0.1.6"

  def project do
    [
      app: :live_message,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: @description,
      docs: [extras: ["README.md"], main: "readme", source_ref: "v#{@version}"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 0.18.3"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:floki, ">= 0.30.0", only: :test}
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README.md),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/Dyad-AI/live_message"}
    ]
  end
end

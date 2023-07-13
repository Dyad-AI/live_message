defmodule LiveMessage.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_message,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: """
      Unified messaging for LiveViews and LiveComponents
      """
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
      {:floki, ">= 0.30.0", only: :test}
    ]
  end
end

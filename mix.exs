defmodule Ltiex.MixProject do
  use Mix.Project

  def project do
    [
      app: :ltiex,
      version: "1.0.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "Ltiex",
      source_url: "https://github.com/Vericus/ltiex",
      docs: [
        # The main page in the docs
        main: "Ltiex",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.10"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end

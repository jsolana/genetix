defmodule Genetix.MixProject do
  use Mix.Project

  def project do
    [
      app: :genetix,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      name: "Genetix",
      package: package(),
      source_url: "https://github.com/jsolana/genetix",
      homepage_url: "https://github.com/jsolana/genetix",
      docs: docs()
    ]
  end

  defp description() do
    "A framework to run genetic algorithms using Elixir"
  end

  defp package() do
    %{
      licenses: ["Apache-2.0"],
      maintainers: ["Javier Solana"],
      links: %{"GitHub" => "https://github.com/jsolana/genetix"}
    }
  end

  defp docs() do
    [
      # The main page in the docs
      main: "README",
      logo: "guides/logo.png",
      extras: ["README.md"]
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
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end

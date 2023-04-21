defmodule Genetix.MixProject do
  use Mix.Project

  def project do
    [
      app: :genetix,
      version: "0.3.0",
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
      main: "readme",
      logo: "guides/logo.png",
      extras: ["README.md"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Genetix.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libgraph, "~> 0.16.0"},
      {:stream_data, "~> 0.5.0", only: :test},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:benchee, "~> 1.1", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:exprof, "~> 0.2.4", only: :dev}
    ]
  end
end

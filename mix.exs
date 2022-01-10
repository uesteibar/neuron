defmodule Neuron.Mixfile do
  use Mix.Project

  @version "5.0.0"
  @github "https://github.com/uesteibar/neuron"

  def project do
    [
      app: :neuron,
      description: "A GraphQL client for elixir.",
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: Coverex.Task],
      aliases: aliases(),
      package: package(),
      deps: deps(),
      docs: docs(),
      dialyzer: [
        plt_add_deps: :transitive,
        plt_add_apps: [:mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    [extra_applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.4", only: :dev, runtime: false},
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.1", optional: true},
      {:poison, "~> 4.0", only: :test, override: true},
      {:mock, "~> 0.3.3", only: :test},
      {:coverex, "~> 1.5", only: :test},
      {:credo, "~> 1.1", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:absinthe_websocket, git: "https://github.com/karlosmid/absinthe_websocket"}
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE.md"
      ],
      links: %{"github" => @github},
      maintainers: ["Unai Esteibar <uesteibar@gmail.com>"],
      licenses: ["ISC"]
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      assets: "assets",
      source_url: @github,
      source_ref: "v#{@version}",
      logo: "assets/logo.png",
      formatters: ["html"]
    ]
  end

  defp aliases do
    [
      test: "test --cover"
    ]
  end
end

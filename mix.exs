defmodule Neuron.Mixfile do
  use Mix.Project

  @version "0.3.0"
  @github "https://github.com/uesteibar/neuron"

  def project do
    [
      app: :neuron,
      description: "A GraphQL client for elixir.",
      version: @version,
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: Coverex.Task],
      aliases: aliases(),
      package: package(),
      deps: deps(),
      docs: docs(),
      source_url: @github,
    ]
  end

  def application do
    [extra_applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11"},
      {:poison, "~> 3.1"},
      {:mock, "~> 0.3.1", only: :test},
      {:coverex, "~> 1.4", only: :test},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:ex_doc, "~> 0.15.1", only: :dev, runtime: false},
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
      licenses: ["ISC"],
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "Neuron",
      extras: ["README.md"],
    ]
  end

  defp aliases do
    [
      test: "test --cover",
    ]
  end
end

# Neuron

[![Build Status](https://travis-ci.org/uesteibar/neuron.svg?branch=master)](https://travis-ci.org/uesteibar/neuron)
[![Hex Version](https://img.shields.io/hexpm/v/neuron.svg)](https://hex.pm/packages/neuron)

A GraphQL client for Elixir.

## Index

- [Installation](#installation)
- [Usage](#usage)
- [Running Locally](#running-locally)
- [Contributing](#contributing)


## Installation

```elixir
def deps do
  [{:neuron, "~> 0.5.0"}]
end
```

## Usage

```elixir
iex> Neuron.Config.set(url: "https://example.com/graph")
iex> Neuron.Config.set(headers: [hackney: [basic_auth: {"username", "password"}]])

iex> Neuron.query("""
    {
      films {
        title
      }
    }
    """)

# Response will be:

{:ok, %Neuron.Response{body: %{"data" => {"films" => [%{"title" => "A New Hope"}]}}%, status_code: 200, headers: []}}

# You can also run mutations

iex> Neuron.mutation("YourMutation()")
```

More extensive documentation can be found at [https://hexdocs.pm/neuron](https://hexdocs.pm/neuron).

## Running locally

Clone the repository
```bash
git clone git@github.com:uesteibar/neuron.git
```

Install dependencies
```bash
cd neuron
mix deps.get
```

To run the tests
```bash
mix test
```

To run the lint
```elixir
mix credo
```

## Contributing

Pull requests are always welcome =)

The project uses [standard-changelog](https://github.com/conventional-changelog/conventional-changelog) to update the [Changelog](https://github.com/uesteibar/neuron/blob/master/CHANGELOG.md) with each commit message and upgrade the package version.
For that reason every contribution should have a title and body that follows the [conventional commits standard](https://conventionalcommits.org/) conventions (e.g. `feat(connection): Make it smarter than Jarvis`).

To make this process easier, you can do the following:

Install `commitizen` and `cz-conventional-changelog` globally
```bash
npm i -g commitizen cz-conventional-changelog
```

Save `cz-conventional-changelog` as default
```bash
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

Instead of `git commit`, you can now run
```
git cz
```
and follow the instructions to generate the commit message.

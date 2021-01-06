<p align="center"><img src="logo/horizontal.png" alt="neuron" height="150px"></p>

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
  [{:neuron, "~> 5.0.0"}]
end
```

## JSON library

Neuron defaults to using Jason for JSON encoding and decoding. To use Jason, add it to your deps

```elixir
{:jason, "~> 1.1"}
```

It is also possible to customize which JSON library that is used

```elixir
Neuron.Config.set(json_library: AnotherJSONLibrary)
```

## Connection

Neuron defaults to using HTTP(S) protocol with HTTPoison for Connecting to GraphQL endpoint. You can however customize that behaviour, by providing custom library, which should implement Neuron.Connection behaviour:

```elixir
defmodule MyConnection do
  @behaviour Neuron.Connection

  @impl Neuron.Connection
  def call(body, options) do
    IO.inspect("NEURON CALLED")
    Neuron.Connection.Http.call(body, options)
  end
end
```

Then set it up in config:

```elixir
Neuron.Config.set(connection_module: MyConnection)
```

## Usage

```elixir
iex> Neuron.Config.set(url: "https://example.com/graph")

iex> Neuron.query("""
      {
        films {
          count
        }
      }
    """)

# Response will be:

{:ok, %Neuron.Response{body: %{"data" => %{"films" => %{ "count": 123 }}}, status_code: 200, headers: []}}

# You can also run mutations

iex> Neuron.query("""
      mutation createUser($name: String!) {
        createUser(name: $name) {
          id
          name
        }
      }
    """,
    %{name: "uesteibar"}
    )

# You can also set url and headers as shown below

iex> Neuron.query("""
      mutation createUser($name: String!) {
        createUser(name: $name) {
          id
          name
        }
      }
    """,
    %{name: "uesteibar"},
    url: "https://example.com/graph",
    headers: [authorization: "Bearer <token>"]
    )
```


### Overriding HTTP Timeout
`HTTPoison` default timeout is 5000ms, in case we need to handle longer timeout, using default `Neuron.Connection` module, we could set `connection_opts` which will be passed to `HTTPoison`. So to override timeout to 15000ms, we could do:

```elixir
iex> Neuron.Config.set(url: "https://example.com/graph", connection_opts: [recv_timeout: 15_000])

iex> Neuron.query("""
      {
        films {
          count
        }
      }
    """)
```

We can also set the timeout for a single request by passing the `connection_opts` to `Neuron.query/3` instead:

```elixir
iex> Neuron.query("...", %{}, connection_opts: [recv_timeout: 15_000])
More extensive documentation can be found at [https://hexdocs.pm/neuron](https://hexdocs.pm/neuron).
```

### Testing

You can mock directly with Mox without a wrapping module.

```elixir
# config/config.exs

config :my_app, neuron_adapter: Neuron

# config/test.exs

config :my_app, neuron_adapter: NeuronMock

# lib

@neuron_adapter Application.get_env(:my_app, :neuron_adapter)
@graphql """
  {
    films {
      count
    }
  }
"""
def films_count, do: @neuron_adapter.query(@graphql)

# in the test

Mox.defmock(NeuronMock, for: Neuron.Behaviour)

query =
  """
    {
      films {
        count
      }
    }
  """
expect(NeuronMock, :query, fn ^query ->
  {:ok, %Neuron.Response{body: %{"data" => %{"films" => %{ "count": 123 }}}, status_code: 200, headers: []}}
end)

assert 123 == MyApp.films_count()
```

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

## Style guide

Code is formatted with `mix format` and `mix credo` should not show warnings.

To format the code and run static code analysis with credo

```elixir
mix format
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

defmodule Neuron do
  @moduledoc """
  Neuron is a GraphQL client for elixir.

  ## Usage

  ```elixir
  iex> Neuron.Config.set(url: "https://example.com/graph")

  iex> Neuron.query(\"""
      {
        films {
          title
        }
      }
      \""")

  # Response will be:
  {:ok, %Neuron.Response{body: %{"data" => {"films" => [%{"title" => "A New Hope"}]}}%, status_code: 200, headers: []}}

  # You can also run mutations
  iex> Neuron.query(\"""
      mutation createUser($name: String!) {
        createUser(name: $name) {
          id
          name
        }
      }
    \""",
    %{name: "uesteibar"}
    )

  """

  @doc """
  runs a query request to your graphql endpoint.

  ## Example

  ```elixir
  Neuron.query(\"""
    {
      films {
        count
      }
    }
  \""")
  ```

  You can pass variables for your query

  ## Example

  ```elixir
  Neuron.query(
  \"""
    mutation createUser($name: String!) {
      createUser(name: $name) {
        id
        name
      }
    }
  \""",
  %{name: "uesteibar"}
  )
  ```

  You can also overwrite parameters set on `Neuron.Config` by passing them as options.

  ## Example

  ```elixir
  Neuron.query(
  \"""
    mutation createUser($name: String!) {
      createUser(name: $name) {
        id
        name
      }
    }
  \""",
  %{name: "uesteibar"},
  url: "https://www.other.com/graphql"
  )
  ```
  """

  alias Neuron.{ConfigUtils, Fragment}

  @spec query(query_string :: String.t(), variables :: map(), options :: keyword()) ::
          {:ok, Neuron.Response.t()}
          | {:error, Neuron.Response.t() | Neuron.JSONParseError.t() | HTTPoison.Error.t()}
  def query(query_string, variables \\ %{}, options \\ []) do
    json_library = ConfigUtils.json_library(options)

    query_string
    |> Fragment.insert_into_query()
    |> build_body()
    |> insert_variables(variables)
    |> json_library.encode!()
    |> run(options)
  end

  defp run(body, options) do
    body
    |> run_query(options)
  end

  defp run_query(body, options) do
    connection_module = ConfigUtils.connection_module(options)
    connection_module.call(body, options)
  end

  defp build_body(query_string), do: %{query: query_string}

  defp insert_variables(body, variables) do
    Map.put(body, :variables, variables)
  end
end

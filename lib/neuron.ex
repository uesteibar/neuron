defmodule Neuron do
  alias Neuron.{Response, Connection, Config, Fragment}

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

  @spec query(query_string :: String.t(), variables :: Map.t(), options :: keyword()) ::
          {:ok, Neuron.Response.t()} | {:error, Neuron.Response.t() | Neuron.JSONParseError.t()}
  def query(query_string, variables \\ %{}, options \\ []) do
    json_library = json_library(options)

    query_string
    |> Fragment.insert_into_query()
    |> build_body()
    |> insert_variables(variables)
    |> json_library.encode!()
    |> run(options)
  end

  @doc """
  Returns the JSON library that is configured in Neuron. Default is Jason.
  """
  @spec json_library :: module()
  def json_library() do
    Config.get(:json_library) || Jason
  end

  defp json_library(options) do
    Keyword.get(options, :json_library, json_library())
  end

  defp run(body, options) do
    body
    |> run_query(options)
    |> handle_response(options)
  end

  defp run_query(body, options) do
    url = url(options)
    headers = build_headers(options)
    connection_opts = connection_options(options)
    Connection.post(url, body, %{headers: headers, connection_opts: connection_opts})
  end

  defp build_body(query_string), do: %{query: query_string}

  defp insert_variables(body, variables) do
    Map.put(body, :variables, variables)
  end

  defp handle_response(response, options) do
    json_library = json_library(options)
    parsed_options = parse_options(options)
    Response.handle(response, json_library, parsed_options)
  end

  defp url(options) do
    Keyword.get(options, :url) || Config.get(:url)
  end

  defp build_headers(options) do
    Keyword.merge(["Content-Type": "application/json"], headers(options))
  end

  defp headers(options) do
    Keyword.get(options, :headers, Config.get(:headers) || [])
  end

  defp parse_options(options) do
    Keyword.get(options, :parse_options, Config.get(:parse_options) || [])
  end

  defp connection_options(options) do
    Keyword.get(options, :connection_opts, Config.get(:connection_opts) || [])
  end
end

defmodule Neuron do
  alias Neuron.{Response, Connection, Config, Fragment}

  @moduledoc """
  Neuron is a GraphQL client for elixir.

  ## Usage

  ```elixir
  iex> Neuron.Config.set(url: "https://example.com/graph")
  iex> Neuron.Config.set(headers: [hackney: [basic_auth: {"username", "password"}]])

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
  iex> Neuron.mutation("YourMutation()")

  """

  @doc """
  runs a query request to your graphql endpoint.

  ## Example

  ```elixir
  Neuron.query(\"""
    {
      films {
        title
      }
    }
  \""")
  ```

  You can also overwrite parameters set on `Neuron.Config` by passing them as options.

  ## Example

  ```elixir
  Neuron.query(
    \"""
    {
      films {
        title
      }
    }
    \""",
    url: "https://api.super.com/graph"
  )
  ```
  """

  @spec query(query_string :: String.t(), options :: keyword()) :: Neuron.Response.t()
  def query(query_string, options \\ []) do
    query_string
    |> construct_query_string(options)
    |> Fragment.insert_into_query()
    |> run(options)
  end

  @doc """
  runs a mutation request to your graphql endpoint

  ## Example

  ```elixir
  Neuron.mutation("YourMutation()")
  ```

  You can also overwrite parameters set on `Neuron.Config` by passing them as options.

  ## Example

  ```elixir
  Neuron.mutation("YourMutation()", url: "https://api.super.com/graph")
  ```
  """

  @spec mutation(query_string :: String.t(), options :: keyword()) :: Neuron.Response.t()
  def mutation(mutation_string, options \\ []) do
    mutation_string
    |> construct_mutation_string(options)
    |> Fragment.insert_into_query()
    |> run(options)
  end

  defp run(body, options) do
    body
    |> run_query(options)
    |> Response.handle()
  end

  defp run_query(body, options) do
    url = url(options)
    headers = build_headers(options)
    Connection.post(url, body, headers)
  end

  defp construct_query_string(query_string, options) do
    if as_json(options) do
      Poison.encode!(%{query: query_string})
    else
      "query #{query_string}"
    end
  end

  defp construct_mutation_string(mutation_string, options) do
    if as_json(options) do
      Poison.encode!(%{mutation: mutation_string})
    else
      "mutation #{mutation_string}"
    end
  end

  defp url(options) do
    Keyword.get(options, :url) || Config.get(:url)
  end

  defp as_json(options) do
    Keyword.get(options, :as_json, Config.get(:as_json))
  end

  defp build_headers(options) do
    as_json(options)
    |> base_headers()
    |> Keyword.merge(headers(options))
  end

  defp headers(options) do
    Keyword.get(options, :headers, Config.get(:headers) || [])
  end

  defp base_headers(true), do: ["Content-Type": "application/json"]
  defp base_headers(_), do: ["Content-Type": "application/graphql"]
end

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
  """

  @spec query(query_string :: String.t()) :: Neuron.Response.t()
  def query(query_string) do
    query_string
    |> construct_query_string()
    |> Fragment.insert_into_query()
    |> run()
  end

  @doc """
  runs a mutation request to your graphql endpoint

  ## Example

  ```elixir
  Neuron.mutation("YourMutation()")
  ```
  """

  @spec mutation(query_string :: String.t()) :: Neuron.Response.t()
  def mutation(mutation_string) do
    mutation_string
    |> construct_mutation_string()
    |> Fragment.insert_into_query()
    |> run()
  end

  defp run(body) do
    body
    |> run_query
    |> Response.handle()
  end

  defp run_query(body) do
    Connection.post(url(), body)
  end

  defp construct_query_string(query_string) do
    "query #{query_string}"
  end

  defp construct_mutation_string(mutation_string) do
    "mutation #{mutation_string}"
  end

  defp url do
    Config.get(:url)
  end
end

defmodule Neuron do
  @moduledoc """
  Allows to interact with graphql endpoints.
  """

  @doc """
  runs a query request to your graphql endpoint
  """
  def query(query_string) do
    query_string
    |> construct_query_string()
    |> run()
  end

  @doc """
  runs a mutation request to your graphql endpoint
  """
  def mutation(mutation_string) do
    mutation_string
    |> construct_mutation_string()
    |> run()
  end

  defp run(body) do
    body
    |> run_query
    |> Neuron.Response.handle()
  end

  defp run_query(body) do
    Neuron.Connection.post(url(), body)
  end

  defp construct_query_string(query_string) do
    "query #{query_string}"
  end

  defp construct_mutation_string(mutation_string) do
    "mutation #{mutation_string}"
  end

  defp url() do
    Neuron.Config.get(:url)
  end
end

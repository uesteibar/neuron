defmodule Neuron do
  alias Neuron.{Response, Connection, Config}

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
    |> include_fragments()
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
    |> include_fragments()
    |> run()
  end

  @doc ~S"""
  registers a fragment that will automatically be added to future mutations and queries that require it

  ## Example

  ```elixir
  Neuron.register_fragment("\"\"
    NameParts on Person {
      firstName
      lastName
    }
  \"\"")
  ```
  """

  @spec register_fragment(query_string :: String.t()) :: :ok
  def register_fragment(query_string), do: register_fragment(:global, query_string)

  @spec register_fragment(context :: :global | :process, query_string :: String.t()) :: :ok

  def register_fragment(:global, query_string) do
    fragment = query_string |> process_fragment
    stored_fragments = Application.get_all_env(:neuron) |> Access.get(:fragments, [])
    Application.put_env(:neuron, :fragments, [fragment | stored_fragments])
  end

  def register_fragment(:process, query_string) do
    fragment = query_string |> process_fragment
    stored_fragments = Process.get() |> Access.get(:fragments, [])
    Process.put(:fragments, [fragment | stored_fragments])
  end

  defp process_fragment(query_string) do
    fragment_name =
      Regex.run(~r/^(\w+)/, query_string, capture: :first) |> List.first() |> String.to_atom()

    fragment = query_string |> construct_fragment_string

    {fragment_name, fragment}
  end

  defp include_fragments(query_string) do
    stored_fragments =
      (Application.get_all_env(:neuron) |> Access.get(:fragments, [])) ++
        (Process.get() |> Access.get(:fragments, []))

    fragments_to_add =
      query_string
      |> find_fragments
      |> Enum.map(&List.keyfind(stored_fragments, &1, 0, &1))

    missing_fragments = fragments_to_add |> Enum.filter(&is_atom/1) |> Enum.map(&Atom.to_string/1)

    if Enum.count(missing_fragments) > 0, do: raise("Fragments #{missing_fragments} not found")

    fragments_to_add
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(query_string, &"#{&1} \n #{&2}")
  end

  # TODO : Ignore '...<word>' in strings within the graphql querys
  defp find_fragments(query_string) do
    Regex.scan(~r/(?<=\.\.\.)\w+/, query_string)
    |> List.flatten()
    |> Enum.map(&String.to_atom/1)
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

  defp construct_fragment_string(fragment_string) do
    "fragment #{fragment_string}"
  end

  defp url do
    Config.get(:url)
  end
end

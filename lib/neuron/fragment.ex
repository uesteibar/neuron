defmodule Neuron.Fragment do
  alias Neuron.Store

  @doc ~S"""
  registers a fragment that will automatically be added to future mutations and queries that require it

  ## Example

      iex> Neuron.Fragment.register("
      ...>  NameParts on Person {
      ...>    firstName
      ...>    lastName
      ...>  }
      ...> ")
      :ok
  """

  @spec register(query_string :: String.t()) :: :ok
  def register(query_string), do: register(:global, query_string)

  @spec register(context :: :global | :process, query_string :: String.t()) :: :ok
  def register(context, query_string) do
    fragment = query_string |> process_fragment_string
    stored_fragments = Store.get(context, :fragments, [])
    Store.set(context, :fragments, [fragment | stored_fragments])
  end

  defp process_fragment_string(query_string) do
    fragment_name = Regex.run(~r/^(?:\W*)(\w+)/, query_string) |> List.last() |> String.to_atom()

    fragment = query_string |> construct_fragment_string

    {fragment_name, fragment}
  end

  @doc false
  def insert_into_query(query_string) do
    stored_fragments = Store.get(:global, :fragments, []) ++ Store.get(:process, :fragments, [])

    fragments_to_add =
      query_string
      |> find_in_query
      |> Enum.map(&List.keyfind(stored_fragments, &1, 0, &1))

    missing_fragments = fragments_to_add |> Enum.filter(&is_atom/1) |> Enum.map(&Atom.to_string/1)

    if Enum.any?(missing_fragments), do: raise("Fragments #{missing_fragments} not found")

    fragments_to_add
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(query_string, &"#{&1} \n #{&2}")
  end

  defp find_in_query(query_string) do
    Regex.scan(~r/(?<=\.\.\.)\w+(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)/, query_string)
    |> List.flatten()
    |> Enum.map(&String.to_atom/1)
  end

  defp construct_fragment_string(fragment_string) do
    "fragment #{fragment_string}"
  end
end

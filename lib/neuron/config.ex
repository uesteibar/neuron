defmodule Neuron.Config do
  alias Neuron.Store

  @moduledoc """
  This module can be used to modify your graphql client configuration
  either globaly or for the current process.
  """

  @doc """
  sets global configuration values for Neuron

  ## Examples

      iex> Neuron.Config.set(url: "http://example.com/graph")
      :ok
  """

  @spec set(value :: keyword()) :: :ok
  def set(value), do: set(:global, value)

  @doc """
  sets global/process configuration values for Neuron

  Available options are:

  - url: graphql endpoint url
  - headers: headers to be sent in the request
  - connection_opts: additional options to be passed to HTTPoison
  - json_library: JSON library. Default is Jason.
  - parse_options: options to be passed to the JSON library when decoding JSON

  ## Examples

      iex> Neuron.Config.set(headers: [name: "val"])
      :ok

      iex> Neuron.Config.set(:process, url: "http://example.com/graph")
      :ok

      iex> Neuron.Config.set(json_library: Jason)
      :ok

      iex> Neuron.Config.set(parse_options: [keys: :atoms])
      :ok
  """

  @spec set(context :: :global | :process, value :: keyword()) :: :ok
  def set(context, value)

  def set(:global, nil) do
    [
      :neuron_url,
      :neuron_headers,
      :neuron_connection_opts,
      :neuron_json_library,
      :neuron_parse_options
    ]
    |> Enum.map(&Store.delete(:global, &1))
  end

  def set(context, url: value), do: Store.set(context, :neuron_url, value)
  def set(context, headers: value), do: Store.set(context, :neuron_headers, value)
  def set(context, connection_opts: value), do: Store.set(context, :neuron_connection_opts, value)
  def set(context, json_library: value), do: Store.set(context, :neuron_json_library, value)
  def set(context, parse_options: value), do: Store.set(context, :neuron_parse_options, value)

  @doc """
  gets configuration value for Neuron

  ## Examples

      iex>Neuron.Config.set(url: "http://example.com/graph")
      iex>Neuron.Config.get(:url)
      "http://example.com/graph"

      iex>Neuron.Config.set(headers: [name: "value"])
      iex>Neuron.Config.get(:headers)
      [name: "value"]

      iex>Neuron.Config.get(:invalid)
      nil

  """
  @spec get(config :: atom()) :: any()
  def get(config)
  def get(:headers), do: get(:neuron_headers)
  def get(:url), do: get(:neuron_url)
  def get(:connection_opts), do: get(:neuron_connection_opts)
  def get(:json_library), do: get(:neuron_json_library)
  def get(:parse_options), do: get(:neuron_parse_options)

  def get(key) do
    key
    |> Store.current_context()
    |> Store.get(key)
  end
end

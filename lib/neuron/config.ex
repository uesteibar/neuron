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
  - as_json: sends requests as json instead of graphql format (e.g Github API v4 only accepts json)

  ## Examples

      iex> Neuron.Config.set(headers: [name: "val"])
      :ok

      iex> Neuron.Config.set(:process, url: "http://example.com/graph")
      :ok
  """

  @spec set(context :: :global | :process, value :: keyword()) :: :ok
  def set(context, value)

  def set(:global, nil) do
    [:neuron_url, :neuron_headers, :neuron_connection_opts]
    |> Enum.map(&Store.delete(:global, &1))
  end

  def set(context, url: value), do: Store.set(context, :neuron_url, value)
  def set(context, headers: value), do: Store.set(context, :neuron_headers, value)
  def set(context, connection_opts: value), do: Store.set(context, :neuron_connection_opts, value)
  def set(context, as_json: value), do: Store.set(context, :neuron_as_json, value)

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
  def get(:as_json), do: get(:neuron_as_json)

  def get(key) do
    key
    |> Store.current_context()
    |> Store.get(key)
  end
end

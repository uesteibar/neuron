defmodule Neuron.Config do
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

  ## Examples

      iex> Neuron.Config.set(headers: ["name": "val"])
      :ok

      iex> Neuron.Config.set(:process, url: "http://example.com/graph")
      :ok
  """

  @spec set(context :: :global | :process, value :: keyword()) :: :ok
  def set(context, value)

  def set(:global, nil) do
    Application.delete_env(:neuron, :neuron_url)
    Application.delete_env(:neuron, :neuron_headers)
    Application.delete_env(:neuron, :neuron_connection_opts)
  end

  def set(:global, url: value) do
    Application.put_env(:neuron, :neuron_url, value)
  end

  def set(:process, url: value) do
    Process.put(:neuron_url, value)
    :ok
  end

  def set(:global, headers: value) do
    Application.put_env(:neuron, :neuron_headers, value)
  end

  def set(:process, headers: value) do
    Process.put(:neuron_headers, value)
    :ok
  end

  def set(:global, connection_opts: value) do
    Application.put_env(:neuron, :neuron_connection_opts, value)
  end

  def set(:process, connection_opts: value) do
    Process.put(:neuron_connection_opts, value)
    :ok
  end

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

  def get(key) do
    key
    |> current_context()
    |> get_config_for()
    |> Access.get(key)
  end

  defp get_config_for(:process), do: Process.get()
  defp get_config_for(:global), do: Application.get_all_env(:neuron)

  @doc false
  def current_context(:headers), do: current_context(:neuron_headers)
  def current_context(:url), do: current_context(:neuron_url)
  def current_context(:connection_opts), do: current_context(:neuron_connection_opts)

  def current_context(key) do
    if Process.get(key, nil), do: :process, else: :global
  end
end

defmodule Neuron.Config do
  @moduledoc """
  Allows to interact with your graphql configuration.
  """

  @doc """
  sets global/process configuration values for Neuron

      iex> Neuron.Config.set(url: "http://example.com/graph")
      :ok

      iex> Neuron.Config.set(headers: ["name": "val"])
      :ok

      iex> Neuron.Config.set(:process, url: "http://example.com/graph")
      :ok
  """
  def set(value), do: set(:global, value)

  def set(:global, nil) do
    Application.delete_env(:neuron, :neuron_url)
    Application.delete_env(:neuron, :neuron_headers)
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

  @doc """
  gets url configuration value for Neuron

      iex>Neuron.Config.set(url: "http://example.com/graph")
      iex>Neuron.Config.get(:url)
      "http://example.com/graph"

      iex>Neuron.Config.set(headers: [name: "value"])
      iex>Neuron.Config.get(:headers)
      [name: "value"]

      iex>Neuron.Config.get(:invalid)
      nil

  """
  def get(:headers), do: get(:neuron_headers)
  def get(:url), do: get(:neuron_url)

  def get(key) do
    key
    |> current_context()
    |> get_config_for()
    |> Access.get(key)
  end

  defp get_config_for(:process), do: Process.get()
  defp get_config_for(:global), do: Application.get_all_env(:neuron)

  def current_context(:headers), do: current_context(:neuron_headers)
  def current_context(:url), do: current_context(:neuron_url)

  def current_context(key) do
    if Process.get(key, nil), do: :process, else: :global
  end
end

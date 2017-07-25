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
    Application.delete_env(:neuron, :url)
    Application.delete_env(:neuron, :headers)
  end
  def set(:global, url: url_value) do
    Application.put_env(:neuron, :url, url_value)
  end
  def set(:process, url: url_value) do
    Process.put(:url, url_value)
    :ok
  end

  def set(:global, headers: header_value) do
    Application.put_env(:neuron, :headers, header_value)
  end
  def set(:process, headers: header_value) do
    Process.put(:headers, header_value)
    :ok
  end

  @doc """
  gets url configuration value for Neuron

      iex>Neuron.Config.set(url: "http://example.com/graph"); Neuron.Config.get(:url)
      "http://example.com/graph"

      iex>Neuron.Config.set(headers: ["name", "value"]); Neuron.Config.get(:headers)
      ["name", "value"]

      iex>Neuron.Config.get(:invalid)
      nil

  """
  def get(key) do
    get_config_for(current_context(key))[key]
  end

  defp get_config_for(:process), do: Process.get()
  defp get_config_for(:global), do: Application.get_all_env(:neuron)

  def current_context(key) do
    if Process.get(key, nil), do: :process, else: :global
  end
end

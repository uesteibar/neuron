defmodule Neuron.Config do
  @moduledoc """
  Allows to interact with your graphql configuration.
  """

  @doc """
  sets global/process configuration values for Neuron

      iex> Neuron.Config.set(url: "http://example.com/graph")
      :ok

      iex> Neuron.Config.set(:process, url: "http://example.com/graph")
      :ok
  """
  def set(value), do: set(:global, value)
  def set(:global, value) do
    Application.put_env(:neuron, :graphql, value)
  end
  def set(:process, value) do
    Process.put(:neuron_graphql, value)
    :ok
  end

  @doc """
  gets url configuration value for Neuron

      iex>Neuron.Config.set(url: "http://example.com/graph"); Neuron.Config.get(:url)
      "http://example.com/graph"
  """
  def get(:url) do
    case get_config_for(current_context()) do
      [url: url] -> url
      _ -> nil
    end
  end

  defp get_config_for(:process), do: Process.get(:neuron_graphql, nil)
  defp get_config_for(:global), do: Application.get_env(:neuron, :graphql, nil)

  def current_context() do
    if Process.get(:neuron_graphql, nil), do: :process, else: :global
  end
end

defmodule Neuron.Config do
  @moduledoc """
  Allows to interact with your graphql configuration.
  """

  @doc """
  sets global configuration values for Neuron

      iex> Neuron.Config.set(url: "http://example.com/graph")
      :ok
  """
  def set(value) do
    Application.put_env(:neuron, :graphql, value)
  end

  @doc """
  gets url configuration value for Neuron

      iex>Neuron.Config.set(url: "http://example.com/graph"); Neuron.Config.get(:url)
      "http://example.com/graph"
  """
  def get(:url) do
    case Application.get_env(:neuron, :graphql, nil) do
      [url: url] -> url
      _ -> nil
    end
  end
end

defmodule Neuron.ConfigUtils do
  @moduledoc """
  This module provides helper functions to read config + options for Neuron.
  """

  alias Neuron.Config

  @doc """
  Returns the JSON library that is configured in Neuron. Default is Jason.
  """
  @spec json_library :: module()
  def json_library() do
    Config.get(:json_library) || Jason
  end

  @doc """
  Returns the JSON library that is configured in Neuron, or overriden in options. Default is Jason.
  """
  def json_library(options) do
    Keyword.get(options, :json_library, json_library())
  end

  @doc """
  Returns the Connection module that is configured in Neuron. Default is Neuron.Connection.Http.
  """
  @spec connection_module :: module()
  def connection_module() do
    Config.get(:connection_module) || Neuron.Connection.Http
  end

  @doc """
  Returns the Connection library that is configured in Neuron, or overriden in options. Default is Neuron.Connection.Http.
  """
  def connection_module(options) do
    Keyword.get(options, :connection_module, connection_module())
  end

  @doc """
  Returns the connection options that is configured in Neuron, or overriden in options.
  """
  def connection_options(options),
    do: Keyword.get(options, :connection_opts, Config.get(:connection_opts) || [])

  @doc """
  Returns the JSON parsing options that is configured in Neuron, or overriden in options.
  """
  def parse_options(options) do
    Keyword.get(options, :parse_options, Config.get(:parse_options) || [])
  end
end

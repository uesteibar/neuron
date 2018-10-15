defmodule Neuron.Store do
  @moduledoc """
  This module provides a simple way to interface with the process and
  application environmental variables, acting as a simple KV store.

  WARNING: this module is not intended to be used outside of this library.
  """

  @doc """
  sets neuron application/process environmental variables

  ## Examples
      iex> Neuron.Store.set(:my_key, "value")
      :ok
  """
  @spec set(key :: atom(), value :: any()) :: :ok
  def set(key, value), do: set(:global, key, value)

  @spec set(context :: :global | :process, value :: keyword()) :: :ok
  def set(:global, key, value) do
    Application.put_env(:neuron, key, value)
  end

  def set(:process, key, value) do
    Process.put(key, value)
    :ok
  end

  @doc """
  returs neuron application/process environmental variables

  ## Examples
      iex> Neuron.Store.set(:my_key, "value")
      :ok
      iex> Neuron.Store.get(:my_key)
      "value"
  """
  @spec get(key :: atom()) :: any()
  def get(key), do: get(:global, key)

  @spec get(context :: :global | :process, key :: atom()) :: any()
  def get(context, key), do: get(context, key, nil)

  @spec get(context :: :global | :process, key :: atom(), default :: any()) :: any()
  def get(:global, key, default), do: Application.get_env(:neuron, key, default)
  def get(:process, key, default), do: Process.get(key, default)

  @doc """
  deletes neuron application/process environmental variables

  ## Examples
      iex> Neuron.Store.delete(:my_key)
      :ok
  """
  @spec delete(key :: atom()) :: any()
  def delete(key), do: delete(:global, key)

  @spec delete(context :: :global | :process, key :: atom()) :: :ok
  def delete(:global, key) do
    Application.delete_env(:neuron, key)
  end

  def delete(:process, key) do
    Process.delete(key)
    :ok
  end

  @doc """
  gets the context of a given neuron application/process environmental variable

  ## Examples
      iex> Neuron.Store.current_context(:my_key)
      :global
  """
  @spec current_context(key :: atom()) :: :global | :process
  def current_context(key) do
    if Process.get(key, nil), do: :process, else: :global
  end
end

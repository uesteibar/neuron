defmodule Neuron.Connection do
  @moduledoc """
  Neuron.Connection is a behaviour for defining pluggable connectors for Neuron library.
  """

  @callback call(String.t(), Keyword.t()) :: {:ok, term} | {:error, term}
end

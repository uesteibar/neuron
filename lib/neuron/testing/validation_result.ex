defmodule Neuron.Testing.ValidationResult do
  @moduledoc ~S"""
  A module representing a result of Neuron test validation.
  """
  @fields [:result, :message]
  @enforce_keys @fields
  defstruct @fields
end

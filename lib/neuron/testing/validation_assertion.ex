defmodule Neuron.Testing.ValidationAssertion do
  @moduledoc ~S"""
  A module representing a condition to be checked in Neuron query test.

  ## Example
    %Neuron.Testing.ValidationAssertion{
      field: :keywords,
      validation: fn keywords ->
        Keyword.get(keywords, :headers) == ["some-header": "1", "some-header2": "2"]
      end,
      message: "Wrong headers in the graphql query."
    }
  """
  @fields [:field, :validation, :message]
  @enforce_keys @fields
  defstruct @fields

  @type t :: %__MODULE__{
          field: atom(),
          validation: (term() -> boolean()),
          message: String.t()
        }
end

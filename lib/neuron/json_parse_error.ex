defmodule Neuron.JSONParseError do
  @moduledoc """
  Struct representation of a JSON parse error.
  """

  alias Neuron.Response

  @type t :: %Neuron.JSONParseError{error: map(), response: Response.t()}

  defstruct response: %Response{},
            error: nil
end

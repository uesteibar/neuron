defmodule Neuron.Response do
  @moduledoc """
  Struct representation of a query response.
  """

  @type t :: %Neuron.Response{body: map(), status_code: integer(), headers: keyword()}

  defstruct body: %{},
            status_code: nil,
            headers: nil
end

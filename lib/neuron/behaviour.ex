defmodule Neuron.Behaviour do
  @moduledoc false

  @callback query(query_string :: String.t(), variables :: map(), options :: keyword()) ::
              {:ok, Neuron.Response.t()}
              | {:error, Neuron.Response.t() | Neuron.JSONParseError.t() | HTTPoison.Error.t()}
end

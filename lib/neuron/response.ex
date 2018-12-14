defmodule Neuron.Response do
  alias Neuron.Response

  @moduledoc """
  Struct representation of a query response.
  """

  @type t :: %Neuron.Response{body: Map.t(), status_code: Integer.t(), headers: keyword()}

  defstruct body: %{},
            status_code: nil,
            headers: nil

  @doc false
  def handle({:ok, %{status_code: 200} = response}, parse_options) do
    {
      :ok,
      %Response{
        status_code: response.status_code,
        body: parse_body(response, parse_options),
        headers: response.headers
      }
    }
  end

  def handle({:ok, response}, parse_options) do
    {
      :error,
      %Response{
        status_code: response.status_code,
        body: parse_body(response, parse_options),
        headers: response.headers
      }
    }
  end

  def handle({:error, response}, _parse_options) do
    {:error, response}
  end

  defp parse_body(response, parse_options) do
    Poison.decode!(response.body, parse_options)
  end

end

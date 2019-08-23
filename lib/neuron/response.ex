defmodule Neuron.Response do
  alias Neuron.{
    Response,
    JSONParseError
  }

  @moduledoc """
  Struct representation of a query response.
  """

  @type t :: %Neuron.Response{body: Map.t(), status_code: Integer.t(), headers: keyword()}

  defstruct body: %{},
            status_code: nil,
            headers: nil

  @doc false
  def handle(response, json_library, parse_options \\ [])

  def handle({:ok, response}, json_library, parse_options) do
    case json_library.decode(response.body, parse_options) do
      {:ok, body} -> build_response(%{response | body: body})
      {:error, error} -> handle_unparsable(response, error)
      {:error, error, _} -> handle_unparsable(response, error)
    end
  end

  def handle({:error, _} = response, _, _), do: response

  @doc false
  def build_response(%{status_code: 200} = response) do
    {
      :ok,
      %Response{
        status_code: response.status_code,
        body: response.body,
        headers: response.headers
      }
    }
  end

  def build_response(response) do
    {
      :error,
      %Response{
        status_code: response.status_code,
        body: response.body,
        headers: response.headers
      }
    }
  end

  def handle_unparsable(response, error) do
    {
      :error,
      %JSONParseError{
        response: build_response(response),
        error: error
      }
    }
  end
end

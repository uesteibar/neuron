defmodule Neuron.Response do
  alias Neuron.{Response, Config}

  @moduledoc """
  Struct representation of a query response.
  """

  @type t :: %Neuron.Response{body: Map.t(), status_code: Integer.t(), headers: keyword()}

  defstruct body: %{},
            status_code: nil,
            headers: nil

  @doc false
  def handle({:ok, %{status_code: 200} = response}) do
    {
      :ok,
      %Response{
        status_code: response.status_code,
        body: parse_body(response),
        headers: response.headers
      }
    }
  end

  def handle({:ok, response}) do
    {
      :error,
      %Response{
        status_code: response.status_code,
        body: parse_body(response),
        headers: response.headers
      }
    }
  end

  def handle({:error, response}) do
    {:error, response}
  end

  defp parse_body(response) do
    Poison.decode!(response.body, parse_options())
  end

  defp parse_options() do
    Config.get(:parse_options) || []
  end
end

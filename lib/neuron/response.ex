defmodule Neuron.Response do
  @moduledoc false
  alias Neuron.Response

  defstruct body: %{},
            status_code: nil,
            headers: nil

  def handle({:ok, %{status_code: 200} = response}) do
    {
      :ok,
      %Response{
        status_code: response.status_code,
        body: parse_body(response)["data"],
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
    Poison.decode!(response.body)
  end
end

defmodule Neuron.Connection do
  alias Neuron.Config
  @moduledoc false

  def post(nil, _) do
    raise ArgumentError, message: "you need to supply an url"
  end

  def post(url, query, headers) do
    HTTPoison.post(
      url,
      query,
      headers,
      connection_opts()
    )
  end

  defp connection_opts() do
    Config.get(:connection_opts) || []
  end
end

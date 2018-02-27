defmodule Neuron.Connection do
  alias Neuron.Config
  @moduledoc false

  def post(nil, _) do
    raise ArgumentError, message: "you need to supply an url"
  end

  def post(url, query) do
    HTTPoison.post(
      url,
      query,
      build_headers()
    )
  end

  defp build_headers() do
    ["Content-Type": "application/graphql"]
    |> Keyword.merge(headers())
  end

  defp headers() do
    Config.get(:headers) || []
  end
end

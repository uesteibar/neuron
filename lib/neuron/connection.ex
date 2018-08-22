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
      build_headers(),
      connection_opts()
    )
  end

  defp build_headers() do
    Config.get(:as_json)
    |> base_headers()
    |> Keyword.merge(headers())
  end

  defp headers() do
    Config.get(:headers) || []
  end

  defp connection_opts() do
    Config.get(:connection_opts) || []
  end

  defp base_headers(true), do: []
  defp base_headers(_), do: ["Content-Type": "application/graphql"]
end

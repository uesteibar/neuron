defmodule Neuron.Connection do
  alias Neuron.Config
  @moduledoc false

  def post(url, _) when is_nil(url) do
    raise ArgumentError, message: "you need to supply an url"
  end 

  def post(url, query) do
    HTTPoison.post(
      url,
      query,
      %{},
      build_headers()
    )
  end

  def build_headers() do
    ["Content-Type": "application/graphql"]
    |> Keyword.merge(headers())
  end

  defp headers() do
    Config.get(:headers)
    |> header_conf
  end

  defp header_conf(headers) when is_nil(headers) do
    []
  end

  defp header_conf(headers) do
    headers
  end
end

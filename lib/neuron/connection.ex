defmodule Neuron.Connection do
  @moduledoc false

  def post(url, query, headers \\ []) do
    HTTPoison.post(
      url,
      query,
      Keyword.merge(["Content-Type": "application/graphql"], headers)
    )
  end
end

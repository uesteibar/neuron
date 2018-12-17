defmodule Neuron.Connection do
  @moduledoc false

  def post(nil, _) do
    raise ArgumentError, message: "you need to supply an url"
  end

  def post(url, query, %{:headers => headers, :connection_opts => connection_opts}) do
    HTTPoison.post(
      url,
      query,
      headers,
      connection_opts
    )
  end
end

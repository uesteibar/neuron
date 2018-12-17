defmodule Neuron.ConnectionTest do
  use ExUnit.Case

  alias Neuron.Connection

  import Mock

  describe "build_headers/0" do
    setup do
      Neuron.Config.set(nil)
      %{url: "http://www.example.com/graph", query: %{}}
    end

    test "with basic auth", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          %HTTPoison.Response{}
        end do
        headers = [hackney: [basic_auth: [user: "password"]]]
        Connection.post(url, query, %{headers: headers, connection_opts: []})

        assert called(
                 HTTPoison.post(
                   url,
                   query,
                   headers,
                   []
                 )
               )
      end
    end

    test "with custom connection options", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          %HTTPoison.Response{}
        end do
        connection_opts = [timeout: 50_000]
        Connection.post(url, query, %{headers: [], connection_opts: connection_opts})

        assert called(HTTPoison.post(url, query, [], timeout: 50_000))
      end
    end
  end
end

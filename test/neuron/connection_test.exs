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
        Connection.post(url, query, hackney: [basic_auth: [user: "password"]])

        assert called(
                 HTTPoison.post(
                   url,
                   query,
                   [
                     hackney: [basic_auth: [user: "password"]]
                   ],
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
        Neuron.Config.set(connection_opts: [timeout: 50_000])
        Connection.post(url, query, [])

        assert called(HTTPoison.post(url, query, [], timeout: 50_000))
      end
    end
  end
end

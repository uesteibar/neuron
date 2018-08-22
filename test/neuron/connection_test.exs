defmodule Neuron.ConnectionTest do
  use ExUnit.Case

  alias Neuron.Connection

  import Mock

  describe "build_headers/0" do
    setup do
      Neuron.Config.set(nil)
      %{url: "http://www.example.com/graph", query: %{}}
    end

    test "sets content-type as default header", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          %HTTPoison.Response{}
        end do
        Connection.post(url, query)
        assert called(HTTPoison.post(url, query, ["Content-Type": "application/graphql"], []))
      end
    end

    test "overwrites content type if supplied", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          %HTTPoison.Response{}
        end do
        Neuron.Config.set(headers: ["Content-Type": "application/json"])
        Connection.post(url, query)
        assert called(HTTPoison.post(url, query, ["Content-Type": "application/json"], []))
      end
    end

    test "with basic auth", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          %HTTPoison.Response{}
        end do
        Neuron.Config.set(headers: [hackney: [basic_auth: [user: "password"]]])
        Connection.post(url, query)

        assert called(
                 HTTPoison.post(
                   url,
                   query,
                   [
                     "Content-Type": "application/graphql",
                     hackney: [basic_auth: [user: "password"]]
                   ],
                   []
                 )
               )
      end
    end

    test "with custom headers", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          %HTTPoison.Response{}
        end do
        Neuron.Config.set(headers: ["X-CUSTOM": "value"])
        Connection.post(url, query)

        assert called(
                 HTTPoison.post(
                   url,
                   query,
                   ["Content-Type": "application/graphql", "X-CUSTOM": "value"],
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
        Connection.post(url, query)

        assert called(
                 HTTPoison.post(
                   url,
                   query,
                   ["Content-Type": "application/graphql"],
                   timeout: 50_000
                 )
               )
      end
    end

    test "with as_json: true", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          %HTTPoison.Response{}
        end do
        Neuron.Config.set(as_json: true)
        Connection.post(url, query)
        Neuron.Config.set(as_json: false)

        assert called(HTTPoison.post(url, query, [], []))
      end
    end
  end
end

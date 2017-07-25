defmodule Neuron.ConnectionTest do
  use ExUnit.Case

  alias Neuron.Connection
  import Mock

  describe "build_headers/0" do
    setup do
      Neuron.Config.set(nil)
      [url: "http://www.example.com/graph", query: %{}]
    end

    test "sets content-type as default header", fixtures do
      with_mock HTTPoison, [
        post: fn(_url, _query, _headers) ->
          %HTTPoison.Response{}
        end
      ] do
        Connection.post(fixtures.url, fixtures.query)
        assert called HTTPoison.post(fixtures.url, fixtures.query, ["Content-Type": "application/graphql"])
      end
    end

    test "overwrites content type if supplied", fixtures do
      with_mock HTTPoison, [
        post: fn(_url, _query, _headers) ->
          %HTTPoison.Response{}
        end
      ] do
        Neuron.Config.set([headers: ["Content-Type": "application/json"]])
        Connection.post(fixtures.url, fixtures.query)
        assert called HTTPoison.post(fixtures.url, fixtures.query, ["Content-Type": "application/json"])
      end
    end

    test "with basic auth", fixtures do
      with_mock HTTPoison, [
        post: fn(_url, _query, _headers) ->
          %HTTPoison.Response{}
        end
      ] do
        Neuron.Config.set(headers: [hackney: [basic_auth: ["user": "password"]]])
        Connection.post(fixtures.url, fixtures.query)
        assert called HTTPoison.post(fixtures.url, fixtures.query, ["Content-Type": "application/graphql", hackney: [basic_auth: ["user": "password"]]])
      end
    end

    test "with custom headers", fixtures do
      with_mock HTTPoison, [
        post: fn(_url, _query, _headers) ->
          %HTTPoison.Response{}
        end
      ] do
        Neuron.Config.set(headers: ["X-CUSTOM": "value"])
        Connection.post(fixtures.url, fixtures.query)
        assert called HTTPoison.post(fixtures.url, fixtures.query, ["Content-Type": "application/graphql", "X-CUSTOM": "value"])
      end
    end
  end
end

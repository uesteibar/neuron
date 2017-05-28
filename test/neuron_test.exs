defmodule NeuronTest do
  use ExUnit.Case

  import Mock

  setup do
    url = "www.example.com/graph"
    Neuron.Config.set(url: url)
    [ url: url ]
  end

  describe "query" do
    test "calls the connection with correct url and query string", fixtures do
      with_mock Neuron.Connection, [
        post: fn(_url, _body) ->
          {:ok, %{body: ~s/{ "users": []}/, status_code: 200, headers: []}}
        end
        ] do
        Neuron.query("users { name }")
        assert called Neuron.Connection.post(fixtures.url, "query users { name }")
      end
    end
  end

  describe "mutation" do
    test "calls the connection with correct url and query string", fixtures do
      with_mock Neuron.Connection, [
        post: fn(_url, _body) ->
          {:ok, %{body: ~s/{ "addUser": { "name": "unai" } }/, status_code: 200, headers: []}}
        end
        ] do
        Neuron.mutation(~s/addUser(name: "unai")/)
        assert called Neuron.Connection.post(fixtures.url, ~s/mutation addUser(name: "unai")/)
      end
    end
  end
end

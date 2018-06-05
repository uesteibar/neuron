defmodule Neuron.ConfigTest do
  use ExUnit.Case
  doctest Neuron.Config

  alias Neuron.Config

  setup do
    Config.set(:global, nil)
    :ok
  end

  describe "set" do
    test "global settings" do
      url = "https://example.com/graph"
      Config.set(:global, url: url)

      assert Config.get(:url) == url
    end

    test "process settings" do
      url = "https://example.com/graph"

      spawn(fn ->
        Config.set(:process, url: url)

        assert Config.get(:url) == url
      end)

      assert Config.get(:url) == nil
    end

    test "Can set multiple settings" do
      Config.set(url: "testurl")
      Config.set(headers: [name: "val"])
      Config.set(connection_opts: [foo: "bar"])

      assert Config.get(:url) == "testurl"
      assert Config.get(:headers) == [name: "val"]
      assert Config.get(:connection_opts) == [foo: "bar"]
    end
  end
end

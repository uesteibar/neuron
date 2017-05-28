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

      assert Config.current_context() == :global
      assert Config.get(:url) == url
    end

    test "process settings" do
      url = "https://example.com/graph"

      spawn(fn ->
        Config.set(:process, url: url)

        assert Config.current_context() == :process
        assert Config.get(:url) == url
      end)

      assert Config.current_context() == :global
      assert Config.get(:url) == nil
    end
  end
end

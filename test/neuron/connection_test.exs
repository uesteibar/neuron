defmodule Neuron.ConnectionTest do
  use ExUnit.Case

  alias Neuron.Connection

  describe "headers function" do

    setup do
      # reset
      Neuron.Config.set(nil)
    end

    test "empty params" do
      assert Connection.build_headers() == ["Content-Type": "application/graphql"]
    end

    test "overwrites content type if supplied" do
      Neuron.Config.set([headers: ["Content-Type": "application/json"]])
      assert Connection.build_headers() == ["Content-Type": "application/json"]
    end

    test "with basic auth" do
      Neuron.Config.set(headers: [hackney: [basic_auth: ["user": "password"]]])
      assert Connection.build_headers() == ["Content-Type": "application/graphql", hackney: [basic_auth: ["user": "password"]]]            
    end

    test "with custom headers" do
      Neuron.Config.set(headers: ["X-CUSTOM": "value"])
      assert Connection.build_headers() == ["Content-Type": "application/graphql", "X-CUSTOM": "value"]
    end
  end
end   
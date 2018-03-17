defmodule NeuronTest do
  use ExUnit.Case

  alias Neuron.Connection

  import Mock

  setup do
    url = "www.example.com/graph"
    Neuron.Config.set(:global, url: url)
    %{url: url}
  end

  describe "query/1" do
    test "calls the connection with correct url and query string", %{url: url} do
      with_mock Connection,
        post: fn _url, _body ->
          {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
        end do
        Neuron.query("users { name }")
        assert called(Connection.post(url, "query users { name }"))
      end
    end
  end

  describe "mutation/1" do
    test "calls the connection with correct url and query string", %{url: url} do
      with_mock Connection,
        post: fn _url, _body ->
          {:ok, %{body: ~s/{"data": {"addUser": {"name": "unai"}}}/, status_code: 200, headers: []}}
        end do
        Neuron.mutation(~s/addUser(name: "unai")/)
        assert called(Connection.post(url, ~s/mutation addUser(name: "unai")/))
      end
    end
  end
end

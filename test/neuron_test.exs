defmodule NeuronTest do
  use ExUnit.Case

  alias Neuron.Connection

  import Mock

  setup do
    url = "www.example.com/graph"
    base_headers = ["Content-Type": "application/graphql"]
    Neuron.Config.set(nil)
    Neuron.Config.set(url: url)
    %{url: url, base_headers: base_headers}
  end

  describe "query/1" do
    test "calls the connection with correct url and query string", %{
      url: url,
      base_headers: base_headers
    } do
      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
        end do
        Neuron.query("users { name }")
        assert called(Connection.post(url, "query users { name }", base_headers))
      end
    end

    test "calls as json if as_json: true", %{url: url} do
      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
        end do
        Neuron.Config.set(as_json: true)
        Neuron.query("users { name }")
        Neuron.Config.set(as_json: false)
        assert called(Connection.post(url, "{\"query\":\"users { name }\"}", []))
      end
    end
  end

  describe "query/2" do
    test "it takes all configs as arguments", %{base_headers: base_headers} do
      url = "www.example.com/another/graph"
      headers = ["X-test-header": 'my_header']

      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
        end do
        Neuron.query("users { name }", url: url, headers: headers)

        assert called(
                 Connection.post(
                   url,
                   "query users { name }",
                   Keyword.merge(base_headers, headers)
                 )
               )
      end
    end
  end

  describe "mutation/1" do
    test "calls the connection with correct url and query string", %{
      url: url,
      base_headers: base_headers
    } do
      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok,
           %{body: ~s/{"data": {"addUser": {"name": "unai"}}}/, status_code: 200, headers: []}}
        end do
        Neuron.mutation(~s/addUser(name: "unai")/)
        assert called(Connection.post(url, ~s/mutation addUser(name: "unai")/, base_headers))
      end
    end

    test "calls as json if as_json: true", %{url: url} do
      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok,
           %{body: ~s/{"data": {"addUser": {"name": "unai"}}}/, status_code: 200, headers: []}}
        end do
        Neuron.Config.set(as_json: true)
        Neuron.mutation(~s/addUser(name: "unai")/)
        Neuron.Config.set(as_json: false)

        assert called(Connection.post(url, "{\"mutation\":\"addUser(name: \\\"unai\\\")\"}", []))
      end
    end
  end

  describe "mutation/2" do
    test "it takes all configs as arguments", %{base_headers: base_headers} do
      url = "www.example.com/another/graph"
      headers = ["X-test-header": 'my_header']

      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
        end do
        Neuron.mutation(~s/addUser(name: "unai")/, url: url, headers: headers)

        assert called(
                 Connection.post(
                   url,
                   ~s/mutation addUser(name: "unai")/,
                   Keyword.merge(base_headers, headers)
                 )
               )
      end
    end
  end
end

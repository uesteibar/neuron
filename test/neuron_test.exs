defmodule NeuronTest do
  use ExUnit.Case

  alias Neuron.Connection

  import Mock

  setup do
    url = "www.example.com/graph"
    json_headers = ["Content-Type": "application/json"]
    Neuron.Config.set(nil)
    Neuron.Config.set(url: url)
    %{url: url, json_headers: json_headers}
  end

  describe "query/1" do
    test "calls the connection with correct url and query string", %{
      url: url,
      json_headers: json_headers
    } do
      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
        end do
        Neuron.query("{ users { name } }")

        assert called(
                 Connection.post(
                   url,
                   "{\"variables\":{},\"query\":\"{ users { name } }\"}",
                   %{headers: json_headers, connection_opts: []}
                 )
               )
      end
    end
  end

  describe "query/2" do
    test "it takes all configs as arguments", %{json_headers: json_headers} do
      url = "www.example.com/another/graph"
      headers = ["X-test-header": 'my_header']
      connection_opts = [timeout: 50_000]

      with_mock Connection,
        post: fn _url, _body, _headers ->
          {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
        end do
        Neuron.query("{ users { name } }", %{},
          url: url,
          headers: headers,
          connection_opts: connection_opts
        )

        assert called(
                 Connection.post(
                   url,
                   "{\"variables\":{},\"query\":\"{ users { name } }\"}",
                   %{
                     headers: Keyword.merge(json_headers, headers),
                     connection_opts: connection_opts
                   }
                 )
               )
      end
    end
  end
end

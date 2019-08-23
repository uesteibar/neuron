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

  describe "json_library/0" do
    test "Test that the default JSON library is Jason" do
      assert Neuron.json_library() == Jason
    end
  end

  describe "query/1" do
    for json_library <- [Jason, Poison] do
      test "calls the connection with correct url and query string using #{json_library}", %{
        url: url,
        json_headers: json_headers
      } do
        json_library = unquote(json_library)
        Neuron.Config.set(json_library: json_library)

        with_mock Connection,
          post: fn _url, _body, _headers ->
            {:ok, %{body: ~s/{"data": {"users": []}}/, status_code: 200, headers: []}}
          end do
          Neuron.query("{ users { name } }")

          assert called(
                   Connection.post(
                     url,
                     json_library.encode!(%{query: "{ users { name } }", variables: %{}}),
                     %{headers: json_headers, connection_opts: []}
                   )
                 )
        end
      end
    end
  end

  describe "query/2" do
    for json_library <- [Jason, Poison] do
      test "it takes all configs as arguments using #{json_library}", %{
        json_headers: json_headers
      } do
        json_library = unquote(json_library)
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
            connection_opts: connection_opts,
            json_library: json_library
          )

          assert called(
                   Connection.post(
                     url,
                     json_library.encode!(%{query: "{ users { name } }", variables: %{}}),
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
end

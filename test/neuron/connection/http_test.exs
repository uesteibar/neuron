defmodule Neuron.Connection.HttpTest do
  use ExUnit.Case

  import Mock

  alias Neuron.{
    Connection,
    Response,
    JSONParseError
  }

  @json_libraries [Jason, Poison]

  def build_response(status_code, body) do
    %{
      body: body,
      headers: [
        {"X-Powered-By", "Express"},
        {"Content-Type", "application/json; charset=utf-8"},
        {"Content-Length", "219"},
        {"ETag", "W/\"db-mvJgYYgL8rU//lf7M3zjvw\""},
        {"Date", "Sun, 28 May 2017 11:40:59 GMT"},
        {"Connection", "keep-alive"}
      ],
      status_code: status_code
    }
  end

  describe "build_headers/0" do
    setup do
      Neuron.Config.set(nil)
      %{url: "http://www.example.com/graph", query: %{}}
    end

    test "missing url raises", %{query: query} do
      assert_raise ArgumentError, "you need to supply an url", fn ->
        Connection.Http.post(query, url: nil, headers: [], connection_opts: [])
      end
    end

    test "with basic auth", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          {:ok, %HTTPoison.Response{}}
        end do
        headers = [hackney: [basic_auth: [user: "password"]]]
        Connection.Http.post(query, url: url, headers: headers, connection_opts: [])

        assert called(
                 HTTPoison.post(
                   url,
                   query,
                   Keyword.put(headers, :"Content-Type", "application/json"),
                   []
                 )
               )
      end
    end

    test "with custom connection options", %{url: url, query: query} do
      with_mock HTTPoison,
        post: fn _url, _query, _headers, _opts ->
          {:ok, %HTTPoison.Response{}}
        end do
        connection_opts = [timeout: 50_000]
        Connection.Http.post(query, url: url, headers: [], connection_opts: connection_opts)

        assert called(
                 HTTPoison.post(url, query, ["Content-Type": "application/json"], timeout: 50_000)
               )
      end
    end
  end

  describe "when successful response" do
    setup do
      %{
        response: build_response(200, ~s/{"data": {"users": []}}/)
      }
    end

    for json_library <- @json_libraries do
      test "returns the parsed Response struct using #{json_library}", %{response: response} do
        json_library = unquote(json_library)
        result = Connection.Http.handle_response({:ok, response}, json_library: json_library)

        expected_result = %Response{
          body: %{"data" => %{"users" => []}},
          headers: response.headers,
          status_code: response.status_code
        }

        assert result == {:ok, expected_result}
      end
    end

    for json_library <- @json_libraries do
      test "returns the parsed Response struct with atom keys in the body map using #{
             json_library
           }",
           %{
             response: response
           } do
        json_library = unquote(json_library)

        result =
          Connection.Http.handle_response(
            {:ok, response},
            json_library: json_library,
            parse_options: [keys: :atoms]
          )

        expected_result = %Response{
          body: %{:data => %{:users => []}},
          headers: response.headers,
          status_code: response.status_code
        }

        assert result == {:ok, expected_result}
      end
    end
  end

  describe "when successful response but with errors in body" do
    setup do
      %{
        response: build_response(200, ~s/{"data": null, "errors": "stuff"}/)
      }
    end

    for json_library <- @json_libraries do
      test "returns the parsed Response struct using #{json_library}", %{
        response: response
      } do
        json_library = unquote(json_library)
        result = Connection.Http.handle_response({:ok, response}, json_library: json_library)

        expected_result = %Response{
          body: %{"data" => nil, "errors" => "stuff"},
          headers: response.headers,
          status_code: response.status_code
        }

        assert result == {:ok, expected_result}
      end
    end
  end

  describe "when response with != 200 status code" do
    setup do
      %{
        response:
          build_response(
            400,
            "{\"errors\":[{\"message\":\"Cannot query field \\\"nam\\\" on type \\\"User\\\". Did you mean \\\"name\\\"?\",\"locations\":[{\"line\":3,\"column\":11}]}]}"
          )
      }
    end

    for json_library <- @json_libraries do
      test "returns the parsed Response struct with errors using #{json_library}", %{
        response: response
      } do
        json_library = unquote(json_library)
        result = Connection.Http.handle_response({:ok, response}, json_library: json_library)

        expected_result = %Response{
          body: %{
            "errors" => [
              %{
                "locations" => [%{"column" => 11, "line" => 3}],
                "message" => "Cannot query field \"nam\" on type \"User\". Did you mean \"name\"?"
              }
            ]
          },
          headers: response.headers,
          status_code: response.status_code
        }

        assert result == {:error, expected_result}
      end
    end
  end

  describe "when error" do
    for json_library <- @json_libraries do
      test "returns the error using #{json_library}" do
        json_library = unquote(json_library)

        result =
          Connection.Http.handle_response({:error, "error message"}, json_library: json_library)

        assert result == {:error, "error message"}
      end
    end
  end

  describe "when response not json parsable" do
    for json_library <- @json_libraries do
      test "returns a JSONParseError using #{json_library}" do
        json_library = unquote(json_library)
        body = "<html><body>This is not the GraphQL URL</body></html>"
        raw_response = build_response(200, body)

        assert {:error, %JSONParseError{}} =
                 Connection.Http.handle_response({:ok, raw_response}, json_library: json_library)
      end
    end

    for json_library <- @json_libraries do
      test "includes a response struct for debugging using #{json_library}" do
        json_library = unquote(json_library)
        body = "<html><body>This is not the GraphQL URL</body></html>"
        raw_response = build_response(200, body)

        assert {_, %{response: {:ok, %Response{} = response}}} =
                 Connection.Http.handle_response({:ok, raw_response}, json_library: json_library)

        assert response.body == raw_response.body
        assert response.headers == raw_response.headers
      end
    end
  end
end

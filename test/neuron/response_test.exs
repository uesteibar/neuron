defmodule Neuron.ResponseTest do
  use ExUnit.Case

  alias Neuron.{
    Response,
    JSONParseError
  }

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

  describe "when successful response" do
    setup do
      %{
        response: build_response(200, ~s/{"data": {"users": []}}/)
      }
    end

    test "returns the parsed Response struct", %{response: response} do
      result = Response.handle({:ok, response})

      expected_result = %Response{
        body: %{"data" => %{"users" => []}},
        headers: response.headers,
        status_code: response.status_code
      }

      assert result == {:ok, expected_result}
    end
  end

  describe "when successful response but with errors in body" do
    setup do
      %{
        response: build_response(200, ~s/{"data": null, "errors": "stuff"}/)
      }
    end

    test "returns the parsed Response struct", %{response: response} do
      result = Response.handle({:ok, response})

      expected_result = %Response{
        body: %{"data" => nil, "errors" => "stuff"},
        headers: response.headers,
        status_code: response.status_code
      }

      assert result == {:ok, expected_result}
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

    test "returns the parsed Response struct with errors", %{response: response} do
      result = Response.handle({:ok, response})

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

  describe "when error" do
    test "returns the error" do
      result = Response.handle({:error, "error message"})

      assert result == {:error, "error message"}
    end
  end

  describe "when response not json parsable" do
    test "returns a JSONParseError" do
      body = "<html><body>This is not the GraphQL URL</body></html>"
      raw_response = build_response(200, body)

      assert {:error, %JSONParseError{}} = Response.handle({:ok, raw_response})
    end

    test "includes a response struct for debugging" do
      body = "<html><body>This is not the GraphQL URL</body></html>"
      raw_response = build_response(200, body)

      assert {_, %{response: {:ok, %Response{} = response}}} =
               Response.handle({:ok, raw_response})

      assert response.body == raw_response.body
      assert response.headers == raw_response.headers
    end
  end
end

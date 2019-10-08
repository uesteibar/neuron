defmodule Neuron.Testing.UnitTest do
  @moduledoc ~S"""
  A module used for testing Neuron queries (using FakeNeuron mock implementation).

  ## Example
    use Neuron.Testing.UnitTest
  """
  alias Neuron.Testing.FakeNeuron, as: FakeNeuron

  @doc ~S"""
  Setup a test to be used as Neuron query test. Called automatically when module is requested by `use`.
  """
  defmacro __using__(_opts) do
    quote do
      import Neuron.Testing.UnitTest,
        only: [neuron_query_test: 2, neuron_called_test: 2]

      alias Neuron.Testing.FakeNeuron, as: FakeNeuron

      setup_all do
        FakeNeuron.setup_all(&assert/2)
        :ok
      end
    end
  end

  @doc ~S"""
  Write a test that will be checking Neuron query using provided assertions.

  ## Example
    neuron_query_test "it must call neuron with provided headers" do
      assertion.(%ValidationAssertion{
        field: :keywords,
        validation: fn keywords ->
          Keyword.get(keywords, :headers) == ["some-header": "1", "some-header2": "2"]
        end,
        message: "Wrong headers in the graphql query."
      })

      operation.(
        SomeModuleCallingNeuron.new()
      )
    end

  """
  defmacro neuron_query_test(name, do: block) do
    quote do
      test unquote(name) do
        var!(assertion) = fn condition -> FakeNeuron.add_assertion(condition) end
        var!(operation) = fn command -> command end
        unquote(block)
        FakeNeuron.valid?()
      end
    end
  end

  @doc ~S"""
  Write a test that will be checking if Neuron query is called specified number of times.

  ## Example
    neuron_called_test times: 1, name: "it must call neuron with provided headers" do
      SomeModuleCallingNeuron.new()
    end

  """
  defmacro neuron_called_test(keywords, do: block) do
    quote do
      test unquote(keywords |> Keyword.get(:name)) do
        unquote(block)
        assert FakeNeuron.counter() == unquote(keywords |> Keyword.get(:times))
      end
    end
  end
end

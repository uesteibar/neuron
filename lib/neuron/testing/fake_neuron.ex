defmodule Neuron.Testing.FakeNeuron do
  @moduledoc """
  This is a mock-replacement for Neuron module.
  """

  use Agent

  def setup_all(assert_function) do
    Agent.start_link(fn -> assert_function end, name: :assert_function)
    Agent.start_link(fn -> "" end, name: :query)
    Agent.start_link(fn -> 0 end, name: :counter)
    Agent.start_link(fn -> [] end, name: :assertions)
    Agent.start_link(fn -> [] end, name: :queries)
  end

  def initialize_response(response) do
    Agent.update(:query, fn _ -> response end)
    Agent.update(:counter, fn _ -> 0 end)
    Agent.update(:assertions, fn _ -> [] end)
    Agent.update(:queries, fn _ -> [] end)
  end

  def value, do: Agent.get(:query, & &1)

  def counter, do: Agent.get(:counter, & &1)

  def set_response(response), do: Agent.update(:query, fn _ -> response end)

  def query(query, params, keywords) do
    Agent.update(:counter, fn state -> state + 1 end)

    Agent.update(:queries, fn queries ->
      [%{query: query, params: params, keywords: keywords} | queries]
    end)

    value()
  end

  def queries, do: Agent.get(:queries, & &1)
  def assertions, do: Agent.get(:assertions, & &1)

  @spec add_assertion(ValidationAssertion.t()) :: atom()
  def add_assertion(assertion),
    do: Agent.update(:assertions, fn assertions -> [assertion | assertions] end)

  def valid? do
    Enum.each(validate(), fn %Neuron.Testing.ValidationResult{result: result, message: message} ->
      assert_function().(result, message)
    end)
  end

  defp assert_function do
    Agent.get(:assert_function, & &1)
  end

  defp validate do
    Enum.map(
      assertions(),
      fn %Neuron.Testing.ValidationAssertion{
           field: field_name,
           validation: validation_lambda,
           message: message
         } ->
        %Neuron.Testing.ValidationResult{
          message: message,
          result:
            Enum.any?(
              queries(),
              fn stored_query ->
                validation_lambda.(stored_query[field_name])
              end
            )
        }
      end
    )
  end
end

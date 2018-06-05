defmodule Neuron.FragmentTest do
  use ExUnit.Case
  doctest Neuron.Fragment

  alias Neuron.Fragment

  @test_fragment """
    Name for Person {
      firstName,
      lastName
    }
  """

  @test_query_without_fragment """
    query users {
      firstName,
      lastName
    }
  """

  @test_query_with_fragment """
    query users {
      ...Name
    }
  """

  @test_mutation_with_quoted_fragment """
    mutation user(email: "...Name@gmail.com") {
      firstName
      lastName
    }
  """

  describe "when no fragments are registered" do
    setup [:clear_stored_fragments]

    test "query containing fragments error" do
      assert_raise RuntimeError, fn ->
        Neuron.query(@test_query_with_fragment)
      end
    end
  end

  describe "when name fragment is registered" do
    setup [:clear_stored_fragments, :register_name_fragment]

    test "fragments are retrievable by name" do
      assert Neuron.Store.get(:fragments) |> Keyword.get(:Name) == "fragment #{@test_fragment}"
    end

    test "correct fragments are inserted into queries" do
      correct_request = "fragment #{@test_fragment} \n #{@test_query_with_fragment}"
      assert Fragment.insert_into_query(@test_query_with_fragment) == correct_request
    end

    test "fragment not inserted if not needed" do
      assert Fragment.insert_into_query(@test_query_without_fragment) ==
               @test_query_without_fragment
    end

    test "fragment not inserted if fragment inside string" do
      assert Fragment.insert_into_query(@test_mutation_with_quoted_fragment) ==
               @test_mutation_with_quoted_fragment
    end
  end

  defp register_name_fragment(_context) do
    Fragment.register(@test_fragment)
  end

  defp clear_stored_fragments(_context) do
    Neuron.Store.delete(:process, :fragments)
    Neuron.Store.delete(:global, :fragments)
  end
end

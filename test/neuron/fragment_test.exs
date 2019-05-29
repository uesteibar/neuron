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

  @test_embedding_fragment """
    Name for Person {
      firstName
      lastName
      ...Age
    }
  """

  @test_embedded_fragment """
    Age for Person {
      years
    }
  """

  @test_recursive_fragment """
    MemberDetails for Person {
      ...Age
      ...Name
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

  @test_query_with_recursive_fragment """
    query users {
      ...Name
      ...MemberDetails
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
      assert Neuron.Store.get(:fragments) |> Keyword.get(:Name) == {"fragment #{@test_fragment}", []}
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

  describe "when query contains embedded fragments" do
    setup [:clear_stored_fragments, :register_embedded_fragments]

    test "correct fragments are inserted into queries" do
      resolved = Fragment.insert_into_query(@test_query_with_fragment)

      assert String.contains?(resolved, "fragment #{@test_embedded_fragment}")
      assert String.contains?(resolved, "fragment #{@test_embedding_fragment}")
      assert String.contains?(resolved, @test_query_with_fragment)
    end

    test "nested fragments are embedded recursively" do
      resolved = Fragment.insert_into_query(@test_query_with_recursive_fragment)

      assert String.contains?(resolved, "fragment #{@test_embedded_fragment}")
      assert String.contains?(resolved, "fragment #{@test_embedding_fragment}")
      assert String.contains?(resolved, "fragment #{@test_recursive_fragment}")
      assert String.contains?(resolved, @test_query_with_recursive_fragment)
      assert Regex.scan(~r/fragment\s+Name/, resolved) |> length() == 1
    end

    test "fragments are deduplicated when referenced more than once" do
      resolved = Fragment.insert_into_query(@test_query_with_recursive_fragment)

      assert Regex.scan(~r/fragment\s+Name/, resolved) |> length() == 1
    end
  end

  defp register_name_fragment(_context) do
    Fragment.register(@test_fragment)
  end

  defp register_embedded_fragments(_context) do
    Fragment.register(@test_embedded_fragment)
    Fragment.register(@test_embedding_fragment)
    Fragment.register(@test_recursive_fragment)
  end

  defp clear_stored_fragments(_context) do
    Neuron.Store.delete(:process, :fragments)
    Neuron.Store.delete(:global, :fragments)
  end
end

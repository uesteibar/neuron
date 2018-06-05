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

  @test_query """
    users {
      ...Name
    }
  """

  describe "when no fragments are registered" do
    test "query containing fragments error" do
      assert_raise RuntimeError, fn ->
        Neuron.query(@test_query)
      end
    end
  end

  describe "when name fragment is registered" do
    setup [:register_name_fragment, :add_url]

    test "fragments are retrievable by name" do
      assert Neuron.Store.get(:fragments) |> Keyword.get(:Name) == "fragment #{@test_fragment}"
    end

    test "correct fragments are inserted into queries" do
      assert Fragment.insert_into_query(@test_query) ==
               "fragment #{@test_fragment} \n #{@test_query}"
    end
  end

  defp register_name_fragment(_context) do
    Fragment.register(@test_fragment)
  end

  defp add_url(_context) do
    url = "www.example.com/graph"
    Neuron.Config.set(:global, url: url)
    %{url: url}
  end
end

defmodule Neuron.StoreTest do
  use ExUnit.Case
  doctest Neuron.Store

  alias Neuron.Store

  describe "set" do
    setup [:clear_store]

    test "inserts into process store" do
      assert :ok == Store.set(:process, :hi, "hola")
      assert "hola" == Process.get(:hi)
    end

    test "inserts into application store" do
      assert :ok == Store.set(:global, :bye, "ciao")
      assert "ciao" == Application.get_env(:neuron, :bye)
    end

    test "inserts into application store by default" do
      assert :ok == Store.set(:wow, "bam")
      assert "bam" == Application.get_env(:neuron, :wow)
    end
  end

  describe "get" do
    setup [:clear_store, :seed_store_data]

    test "returns default value if key not found" do
      assert nil == Store.get(:global, :unknown)
      assert nil == Store.get(:process, :unknown)
      assert :missing == Store.get(:global, :unknown, :missing)
      assert :missing == Store.get(:process, :unknown, :missing)
    end

    test "returns stored elements from process" do
      assert "hola" == Store.get(:process, :hi)
    end

    test "returns stored elements from application" do
      assert "ciao" == Store.get(:global, :bye)
    end

    test "returns from application store by default" do
      assert "qux" == Store.get(:baz)
    end
  end

  describe "delete" do
    setup [:clear_store, :seed_store_data]

    test "removes keys from process store" do
      assert :ok == Store.delete(:process, :hi)
      assert :not_found == Process.get(:hi, :not_found)
    end

    test "removes keys from application store" do
      assert :ok == Store.delete(:global, :bye)
      assert :not_found == Application.get_env(:neuron, :bye, :not_found)
    end

    test "deletes from application store by default" do
      assert :ok == Store.delete(:baz)
      assert :not_found == Application.get_env(:neuron, :baz, :not_found)
    end
  end

  describe "current_context" do
    setup [:clear_store, :seed_store_data]

    test "returns correct context for keys" do
      assert :process == Store.current_context(:hi)
      assert :global == Store.current_context(:bye)
    end

    test "returns global for unknown keys" do
      assert :global == Store.current_context(:unknown)
    end
  end

  defp clear_store(_context) do
    Application.delete_env(:neuron, :hi)
    Application.delete_env(:neuron, :bye)
    Process.delete(:hi)
    Process.delete(:bye)
    :ok
  end

  defp seed_store_data(_context) do
    Process.put(:hi, "hola")
    Application.put_env(:neuron, :bye, "ciao")
    Process.put(:foo, "bar")
    Application.put_env(:neuron, :baz, "qux")
    :ok
  end
end

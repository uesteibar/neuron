defmodule SubscriptionExample do

  @url "https://my.awesome.graphql/endpoint"
  @query """
  subscription {
    user {
      name
    }
  }
  """

  def start_link() do
    Neuron.Subscription.start_link(ws_url: @url, query: @query, name: __MODULE__, subscriber: __MODULE__, variables: %{}, callback: :handle_update)
  end

  def handle_update(data, state) do
    IO.puts("Received Update - #{inspect(data)}")

    {:ok, state}
  end
end

defmodule NeuronSubscriptionTest do
  use ExUnit.Case

  describe "subscription" do
    test "ok" do
      {:ok, _pid} = SubscriptionExample.start_link()
    end
  end
end

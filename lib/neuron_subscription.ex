defmodule Neuron.Subscription do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(Neuron.Subscription, opts)
  end

  @impl :true
  def init(opts) do
    query = Keyword.fetch!(opts, :query)
    name = Keyword.fetch!(opts, :name)
    variables = Keyword.fetch!(opts, :variables)
    callback = Keyword.fetch!(opts, :callback)

    subscription_server_name = Module.concat([name, Caller, SubscriptionServer])

    AbsintheWebSocket.SubscriptionServer.subscribe(
      subscription_server_name,
      name,
      callback,
      query,
      variables
    )
    {:ok, opts}
  end

  def supervisor(subscriber: subscriber, url: url) do

    {AbsintheWebSocket.Supervisor,
     [
       subscriber: subscriber,
       url: url,
       token: nil,
       base_name: subscriber,
       async: true
     ]}

  end
end

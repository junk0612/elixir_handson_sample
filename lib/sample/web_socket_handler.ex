defmodule Sample.WebSocketHandler do
  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init(opts) do
    Phoenix.PubSub.subscribe(:chat_pubsub, "mytopic")
    {:ok, opts}
  end

  def websocket_handle({:text, content}, opts) do
    Phoenix.PubSub.broadcast(:chat_pubsub, "mytopic", {:text, content})
    {:ok, opts}
  end

  def websocket_handle(_flame, opts) do
    {:ok, opts}
  end

  def websocket_info({:text, content}, opts) do
    {:reply, {:text, content}, opts}
  end

  def websocket_info(_info, opts) do
    {:ok, opts}
  end

  def terminate(_reason, _req, _opts) do
    Phoenix.PubSub.unsubscribe(:chat_pubsub, "mytopic")
  end
end

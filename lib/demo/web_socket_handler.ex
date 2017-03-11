# WebSocket Handler
# ref: https://ninenines.eu/docs/en/cowboy/2.0/manual/cowboy_websocket/
#
defmodule Demo.WebSocketHandler do
  @behaviour :cowboy_websocket

  # [Required]
  def init(req, opts) do
    {:cowboy_websocket, req, opts}
  end

  # [Optional]
  def websocket_init(opts) do
    Phoenix.PubSub.subscribe(:chat_pubsub, "mytopic")
    {:ok ,opts}
  end

  # [Required]
  def websocket_handle({:text, content}, opts) do
    Phoenix.PubSub.broadcast(:chat_pubsub, "mytopic", {:text, content})
    {:ok, opts}
  end

  # [Required]
  def websocket_handle(_frame, opts) do
    {:ok, opts}
  end

  # [Required]
  def websocket_info({:text, content}, opts) do
    {:reply, {:text, content}, opts}
  end

  # [Required]
  def websocket_info(_info, opts) do
    {:ok, opts}
  end

  # [Optional]
  # def terminate(reason, undefined, state) do
  # end
end

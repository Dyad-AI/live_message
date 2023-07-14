defmodule LiveMessage.SendFunctions do
  @moduledoc """
  The `send_info/2` and `send_info_after/3` functions that are imported into all LiveViews and LiveComponents
  """

  alias Phoenix.LiveView
  alias LiveMessage.Id.LiveViewId
  alias LiveMessage.Id.LiveComponentId

  @doc """
  Sends `message` to `target` asynchronously.

  ## Parameters

    - message: the message to be sent, this can be any term.
    - target: the LiveMessage.Id of the LiveView or LiveComponent. This can be found using the `@me` assign.
    - time: time in milliseconds to wait before sending the message.

  """
  def send_info(%LiveViewId{}, message) do
    send(self(), message)
  end

  def send_info(%LiveComponentId{} = target, message) do
    LiveView.send_update(target.module, id: target.id, __live_message: message)
  end

  @doc """
  Sends `message` to `target` after `time` milliseconds.

  ## Parameters

    - message: the message to be sent, this can be any term.
    - target: the LiveMessage.Id of the LiveView or LiveComponent. This can be found using the `@me` assign.
    - time: time in milliseconds to wait before sending the message.

  """
  def send_info_after(%LiveViewId{}, message, time) do
    Process.send_after(self(), message, time)
  end

  def send_info_after(%LiveComponentId{} = target, message, time) do
    LiveView.send_update_after(target.module, [id: target.id, __live_message: message], time)
  end
end

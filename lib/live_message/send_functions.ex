defmodule LiveMessage.SendFunctions do
  @moduledoc ~S"""
  The `send_info/2` and `send_info_after/3` functions that are imported into all LiveViews and LiveComponents
  """

  alias Phoenix.LiveView
  alias LiveMessage.Id.LiveViewId
  alias LiveMessage.Id.LiveComponentId

  def send_info(%LiveViewId{}, message) do
    send(self(), message)
  end

  def send_info(%LiveComponentId{} = component, message) do
    LiveView.send_update(component.module, id: component.id, __live_message: message)
  end

  def send_info_after(%LiveViewId{}, message, time) do
    Process.send_after(self(), message, time)
  end

  def send_info_after(%LiveComponentId{} = component, message, time) do
    LiveView.send_update_after(
      component.module,
      [id: component.id, __live_message: message],
      time
    )
  end
end

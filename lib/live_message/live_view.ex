defmodule LiveMessage.LiveView do
  @moduledoc ~S"""
  When a LiveView has `use LiveMessage.LiveView` it will have a `@me` assign that can be used as a target for `send_info/2` and `send_info_after/3`
  """

  defmacro __using__(_opts) do
    quote do
      import LiveMessage.SendFunctions
      on_mount(LiveMessage.LiveView)
    end
  end

  import Phoenix.Component
  alias LiveMessage.Id

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, me: Id.for_live_view())}
  end
end

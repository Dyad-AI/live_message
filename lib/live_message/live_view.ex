defmodule LiveMessage.LiveView do
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

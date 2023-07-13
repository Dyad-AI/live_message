defmodule MailroomWeb.LiveMessaging.LiveView do
  defmacro __using__(_opts) do
    quote do
      import MailroomWeb.LiveMessaging.SendFunctions
      on_mount(MailroomWeb.LiveMessaging.LiveView)
    end
  end

  import Phoenix.Component
  alias MailroomWeb.LiveMessaging.Id

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, me: Id.for_live_view())}
  end
end

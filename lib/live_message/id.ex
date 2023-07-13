defmodule MailroomWeb.LiveMessaging.Id do
  alias MailroomWeb.LiveMessaging.Id.LiveViewId
  alias MailroomWeb.LiveMessaging.Id.LiveComponentId

  defmodule LiveComponentId do
    defstruct [:module, :id]
  end

  def for_live_view, do: LiveViewId
  def for_component(module, component_id), do: %LiveComponentId{module: module, id: component_id}
end

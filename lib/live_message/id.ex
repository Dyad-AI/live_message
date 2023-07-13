defmodule LiveMessage.Id do
  alias LiveMessage.Id.LiveViewId
  alias LiveMessage.Id.LiveComponentId

  defmodule LiveComponentId do
    defstruct [:module, :id]
  end

  defmodule LiveViewId do
    defstruct []
  end

  def for_live_view, do: %LiveViewId{}
  def for_component(module, component_id), do: %LiveComponentId{module: module, id: component_id}
end

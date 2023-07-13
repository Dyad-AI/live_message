defmodule LiveMessage.Id do
  @moduledoc ~S"""
  Used to create IDs for LiveViews and LiveComponents that can be used as a target for `send_info/2` and `send_info_after/3`
  """

  alias LiveMessage.Id.LiveViewId
  alias LiveMessage.Id.LiveComponentId

  defmodule LiveComponentId do
    @moduledoc ~S"""
    A struct representing the ID of a LiveComponent that can be used as a target for `send_info/2` and `send_info_after/3`
    """

    defstruct [:module, :id]
  end

  defmodule LiveViewId do
    @moduledoc ~S"""
    A struct representing the ID of a LiveView that can be used as a target for `send_info/2` and `send_info_after/3`
    """

    defstruct []
  end

  def for_live_view, do: %LiveViewId{}
  def for_component(module, component_id), do: %LiveComponentId{module: module, id: component_id}
end

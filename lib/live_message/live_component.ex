defmodule LiveMessage.LiveComponent do
  @moduledoc ~S"""
  When a LiveComponent has `use LiveMessage.LiveComponent` it will have a `@me` assign that can be used as a target for `send_info/2` and `send_info_after/3`

  This will also allow the LiveComponent to receive messages in `handle_info/3`
  """

  # Decorates a LiveComponent's `update/2` function to allow for:
  #   - live messages to be intercepted and sent to `handle_info/2`
  #   - the component ID to be set assigned to `@me` to be used as a target for messages

  defmacro __using__(_opts) do
    quote do
      import LiveMessage.SendFunctions
      require LiveMessage.LiveComponent

      @has_update_function false

      @on_definition LiveMessage.LiveComponent
      @before_compile LiveMessage.LiveComponent
    end
  end

  def __on_definition__(env, :def, :update, [_, _], _guards, _body) do
    Module.put_attribute(env.module, :has_update_function, true)
  end

  def __on_definition__(_env, _kind, _name, _args, _guards, _body), do: :ok

  defmacro __before_compile__(_env) do
    quote do
      if @has_update_function do
        # The LiveComponent has `update/2` defined so override it with another update function
        # that decorates the underlying (super) `update/2`

        defoverridable update: 2

        def update(assigns, socket) do
          LiveMessage.LiveComponent.update_decorator(
            __MODULE__,
            assigns,
            socket,
            %{update: &super/2, module: __MODULE__}
          )
        end
      else
        # The LiveComponent does not have `update/2` defined so add one which
        # decorates `default_update/2` (what happens in a LiveComponent when no `update/2` is specified)

        def update(assigns, socket) do
          LiveMessage.LiveComponent.update_decorator(
            __MODULE__,
            assigns,
            socket,
            %{update: &LiveMessage.LiveComponent.default_update/2, module: __MODULE__}
          )
        end
      end
    end
  end

  import Phoenix.Component, only: [assign: 2]
  alias LiveMessage.Id

  def default_update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def update_decorator(module, %{__live_message: message}, socket, _) do
    {:noreply, socket} = module.handle_info(message, socket)

    {:ok, socket}
  end

  def update_decorator(_, %{id: id} = assigns, socket, opts) do
    socket = assign(socket, me: Id.for_component(opts.module, id))

    opts.update.(assigns, socket)
  end

  def update_decorator(_, assigns, socket, opts) do
    opts.update.(assigns, socket)
  end
end

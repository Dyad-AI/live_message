defmodule MailroomWeb.LiveMessaging.LiveComponent do
  # Decorates a LiveComponent's `update/2` function to allow for:
  #   - live messages to be intercepted and sent to `handle_info/2`
  #   - the component ID to be set assigned to `@me` to be used as a target for messages

  defmacro __using__(_opts) do
    quote do
      import MailroomWeb.LiveMessaging.SendFunctions
      require MailroomWeb.LiveMessaging.LiveComponent

      @has_update_function false

      @on_definition MailroomWeb.LiveMessaging.LiveComponent
      @before_compile MailroomWeb.LiveMessaging.LiveComponent
    end
  end

  def __on_definition__(env, :def, :update, [_, _], _guards, _body) do
    Module.put_attribute(env.module, :has_update_function, true)
  end

  def __on_definition__(_env, _kind, _name, _args, _guards, _body), do: :ok

  defmacro __before_compile__(_env) do
    quote do
      if @has_update_function do
        defoverridable update: 2

        def update(assigns, socket) do
          MailroomWeb.LiveMessaging.LiveComponent.update_decorator(
            __MODULE__,
            assigns,
            socket,
            %{update: &super/2, module: __MODULE__}
          )
        end
      else
        def update(assigns, socket) do
          MailroomWeb.LiveMessaging.LiveComponent.update_decorator(
            __MODULE__,
            assigns,
            socket,
            %{update: &MailroomWeb.LiveMessaging.LiveComponent.default_update/2, module: __MODULE__}
          )
        end
      end
    end
  end

  import Phoenix.Component, only: [assign: 2]
  alias MailroomWeb.LiveMessaging.Id

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

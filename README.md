# LiveMessage

Add unified messaging for LiveViews and LiveComponents, to allow for simple decomposition of LiveViews into LiveComponents.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `live_message` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:live_message, "~> 0.1.0"}
  ]
end
```

Next, add the following imports to your web file in `lib/my_app_web.ex`:

```elixir
# lib/my_app_web.ex

def live_view do
  quote do
    use Phoenix.LiveView
    use LiveMessaging.LiveView
    # ...
  end
end

def live_component do
  quote do
    use Phoenix.LiveComponent
    use LiveMessage.LiveComponent
    # ...
  end
end
```

## Usage


From any LiveView or LiveComponent you can:
```
send_info(target, message)
```

which will trigger a `handle_info/2` in the target LIveView or LiveComponent:
```
def handle_info(message, socket) do
  ....
  {:noreply, socket}
end
```

The "target" here is the ID of the LiveView or LiveComponent available though the `@me` assign, e.g.
```
<.live_component module={MyComponent} id="my_component"
  target={@me}
/>
```

Think of `@me` as a `@myself` but for live messaging.

Also available is `send_info_after/3`:
```
send_info_after(target, message, time)
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/live_message>.

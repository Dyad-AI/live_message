![CI](https://github.com/Dyad-AI/live_message/actions/workflows/ci.yml/badge.svg) [![Hex.pm](https://img.shields.io/hexpm/v/live_message.svg)](https://hex.pm/packages/live_message) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/live_message/)

# LiveMessage

Unified messaging for LiveViews and LiveComponents, to allow for simple decomposition of LiveViews into LiveComponents.

## Usage

From any LiveView or LiveComponent you can:

```elixir
send_info(target, message)
```

or

```elixir
send_info_after(target, message, time)
```

which will trigger a `handle_info/2` in the target LIveView or LiveComponent:

```elixir
def handle_info(message, socket) do
  ....
  {:noreply, socket}
end
```

The "target" here is the ID of the LiveView or LiveComponent available though the `@me` assign, e.g.

```heex
<.live_component module={MyComponent} id="my_component"
  target={@me}
/>
```

Think of `@me` like `@myself` but for live messaging.

## Installation

The package can be installed by adding `live_message` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:live_message, "~> 0.1.0"}
  ]
end
```

Next, add the following `use` statements to your web file in `lib/my_app_web.ex`:

```elixir
# lib/my_app_web.ex

def live_view do
  quote do
    # ...
    use LiveMessage.LiveView
  end
end

def live_component do
  quote do
    # ...
    use LiveMessage.LiveComponent
  end
end
```

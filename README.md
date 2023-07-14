LiveMessage
===========

![CI](https://github.com/Dyad-AI/live_message/actions/workflows/ci.yml/badge.svg) [![Hex.pm](https://img.shields.io/hexpm/v/live_message.svg)](https://hex.pm/packages/live_message) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/live_message/)

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

## Motivation

LiveComponents are a great way to break up large LiveViews into smaller reusable components. But what happens when your LiveComponents
get too big? You could break them down into smaller components, but this comes with  a couple of issues:

- LiveComponents get coupled to their parent
- LiveComponent message handling is coupled to initialisation

# LiveComponents get coupled to their parent

In order for a LiveComponent to communicate to it's parent, it needs to send messages. If it's parent is a LiveView you need `send/2`,
but if it's parent is a LiveComponent you need `LiveView.send_update/2`. So a component needs to know what it's parent is and handle that variation.

# LiveComponent message handling is coupled to initialisation

To send a message to a LiveComponent you use `LiveView.send_update/2` and this is handled in the `update/2` function. Typically `update/2`
is used to set the assigns for the LiveComponent, so for it to also be the message handling function feels like these concerns have not been properly separated:


```elixir
def update(%{my_message: message}, socket) do
  # handle message
  {:ok, socket}
end

def update(assigns, socket) do
  # Initialise state
  {:ok, socket}
end
```

# The solution

LiveMessage solves both these issues by providing a unified way to message LiveViews and LiveComponents that both use `handle_info/2` to handle the messages.

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

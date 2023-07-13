defmodule LiveMessageTest do
  use ExUnit.Case, async: false

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint LiveMessageTest.Endpoint

  describe "send_info/2" do
    test "can send a message to a LiveView" do
      defmodule SendToLiveView.Component do
        use Phoenix.LiveComponent
        use LiveMessage.LiveComponent

        def render(assigns) do
          ~H"""
          <button id="send-button" phx-click="send" phx-target={@myself}>Send</button>
          """
        end

        def handle_event("send", _, socket) do
          send_info(socket.assigns.target, :the_message)

          {:noreply, socket}
        end
      end

      defmodule SendToLiveView.LiveView do
        use Phoenix.LiveView
        use LiveMessage.LiveView
        alias SendToLiveView.Component

        def render(assigns) do
          ~H"""
          <.live_component module={Component} target={@me} id="the_component" />
          <%= assigns[:result] %>
          """
        end

        def handle_info(:the_message, socket) do
          {:noreply, assign(socket, result: "RECEIVED")}
        end
      end

      {:ok, view, _html} = build_conn() |> live_isolated(SendToLiveView.LiveView)

      view |> element("#send-button") |> render_click()

      assert render(view) =~ ~s|RECEIVED|
    end

    test "can send a message to a LiveComponent" do
      defmodule SendToComponent.SubComponent do
        use Phoenix.LiveComponent
        use LiveMessage.LiveComponent

        def render(assigns) do
          ~H"""
          <button id="send-button" phx-click="send" phx-target={@myself}>Send</button>
          """
        end

        def handle_event("send", _, socket) do
          send_info(socket.assigns.target, :the_message)

          {:noreply, socket}
        end
      end

      defmodule SendToComponent.Component do
        use Phoenix.LiveComponent
        use LiveMessage.LiveComponent
        alias SendToComponent.SubComponent

        def render(assigns) do
          ~H"""
          <div>
            <.live_component module={SubComponent} target={@me} id="the_sub_component" />
            <%= assigns[:result] %>
          </div>
          """
        end

        def handle_info(:the_message, socket) do
          {:noreply, assign(socket, result: "RECEIVED")}
        end
      end

      defmodule SendToComponent.LiveView do
        use Phoenix.LiveView
        use LiveMessage.LiveView
        alias SendToComponent.Component

        def render(assigns) do
          ~H"""
          <.live_component module={Component} id="the_component" />
          """
        end
      end

      {:ok, view, _html} = build_conn() |> live_isolated(SendToComponent.LiveView)

      view |> element("#send-button") |> render_click()

      assert render(view) =~ ~s|RECEIVED|
    end

    test "can send a message to a LiveComponent which defines update/2" do
      defmodule SendToComponentWithUpdate.SubComponent do
        use Phoenix.LiveComponent
        use LiveMessage.LiveComponent

        def render(assigns) do
          ~H"""
          <button id="send-button" phx-click="send" phx-target={@myself}>Send</button>
          """
        end

        def update(assigns, socket) do
          {:ok, assign(socket, target: assigns.target)}
        end

        def handle_event("send", _, socket) do
          send_info(socket.assigns.target, :the_message)

          {:noreply, socket}
        end
      end

      defmodule SendToComponentWithUpdate.Component do
        use Phoenix.LiveComponent
        use LiveMessage.LiveComponent
        alias SendToComponentWithUpdate.SubComponent

        def render(assigns) do
          ~H"""
          <div>
            <.live_component module={SubComponent} target={@me} id="the_sub_component" />
            <%= assigns[:result] %>
          </div>
          """
        end

        def handle_info(:the_message, socket) do
          {:noreply, assign(socket, result: "RECEIVED")}
        end
      end

      defmodule SendToComponentWithUpdate.LiveView do
        use Phoenix.LiveView
        use LiveMessage.LiveView
        alias SendToComponentWithUpdate.Component

        def render(assigns) do
          ~H"""
          <.live_component module={Component} id="the_component" />
          """
        end
      end

      {:ok, view, _html} = build_conn() |> live_isolated(SendToComponentWithUpdate.LiveView)

      view |> element("#send-button") |> render_click()

      assert render(view) =~ ~s|RECEIVED|
    end
  end
end

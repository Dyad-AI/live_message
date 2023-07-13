defmodule LiveMessageTest do
  alias Phoenix.LiveComponent
  use ExUnit.Case, async: false

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint LiveMessageTest.Endpoint

  describe "send_info/2" do
    defmodule ComponentToLiveView.Component do
      use Phoenix.LiveComponent
      use LiveMessage.LiveComponent

      def render(assigns) do
        ~H"""
        <button id="button" phx-click="send" phx-target={@myself}>Send</button>
        """
      end

      def handle_event("send", _, socket) do
        send_info(socket.assigns.target, :the_message)

        {:noreply, socket}
      end
    end

    defmodule ComponentToLiveView.LiveView do
      use Phoenix.LiveView
      use LiveMessage.LiveView
      alias ComponentToLiveView.Component

      def render(assigns) do
        ~H"""
        <.live_component module={Component} target={@me} id="my_component" />
        <%= assigns[:result] %>
        """
      end

      def handle_info(:the_message, socket) do
        {:noreply, assign(socket, result: "RECEIVED")}
      end
    end

    test "can send a message from a LiveComponent to a LiveView" do
      {:ok, view, _html} = build_conn() |> live_isolated(ComponentToLiveView.LiveView)

      view |> element("#button") |> render_click()

      assert render(view) =~ ~s|RECEIVED|
    end
  end
end

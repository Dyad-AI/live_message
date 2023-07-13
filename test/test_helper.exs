ExUnit.start()

defmodule LiveMessageTest.Router do
  use Phoenix.Router

  pipeline :browser do
    plug(:fetch_session)
  end
end

defmodule LiveMessageTest.ErrorView do
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end

Application.put_env(:live_message, LiveMessageTest.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: "Hu4qQN3iKzTV4fJxhorPQlA/osH9fAMtbtjVS58PFgfw3ja5Z18Q/WSNR9wP4OfW",
  live_view: [signing_salt: "hMegieSe"],
  render_errors: [view: LiveMessageTest.ErrorView],
  check_origin: false
)

defmodule LiveMessageTest.Endpoint do
  use Phoenix.Endpoint, otp_app: :live_message

  plug(Plug.Session,
    store: :cookie,
    key: "_live_view_key",
    signing_salt: "/VEDsdfsffMnp5"
  )

  plug(LiveMessageTest.Router)
end

Supervisor.start_link([LiveMessageTest.Endpoint], strategy: :one_for_one)

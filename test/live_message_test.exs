defmodule LiveMessageTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest

  @endpoint LiveMessageTest.Endpoint

  test "compiles" do
    assert build_conn() |> get("/") |> html_response(200) =~ ~s|Hi|
  end
end

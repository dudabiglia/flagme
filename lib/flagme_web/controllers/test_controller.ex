defmodule FlagmeWeb.TestController do
  use FlagmeWeb, :controller

  def run(conn, _params) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end
end

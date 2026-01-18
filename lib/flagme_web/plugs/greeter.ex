defmodule FlagmeWeb.Plugs.Greeter do
  def init(default), do: default

  def call(conn, _default) do
    user_name = conn.body_params["user_name"] || "Friend"

    IO.puts("Hello #{user_name}")

    conn
  end
end

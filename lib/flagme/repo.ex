defmodule Flagme.Repo do
  use Ecto.Repo,
    otp_app: :flagme,
    adapter: Ecto.Adapters.Postgres
end

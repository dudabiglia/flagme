defmodule Flagme.Auth.Pipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :flagme,
    module: Flagme.Guardian,
    error_handler: Flagme.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)
end

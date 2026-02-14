defmodule Flagme.Guardian do
  use Guardian, otp_app: :flagme

  alias Flagme.Accounts

  # gets the id of the user from the resource and
  # returns it to be added as the sub of the JTW
  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)

    {:ok, sub}
  end

  # does the reverse of the previous fn
  # gets the sub from the token's claims
  # and fetches the user that has that id
  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get!(id)
    {:ok, resource}
  end
end

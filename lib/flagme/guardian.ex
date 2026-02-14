defmodule Flagme.Guardian do
  use Guardian, otp_app: :flagme

  use Guardian.Permissions, encoding: Guardian.Permissions.BitwiseEncoding

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

  def build_claims(claims, _resource, opts) do
    claims = encode_permissions_into_claims!(claims, Keyword.get(opts, :permissions))
    {:ok, claims}
  end

  def build_permissions(permissions) when is_map(permissions) do
    Map.new(permissions, fn {group, perms} ->
      {String.to_atom(group), Enum.map(perms, &String.to_atom/1)}
    end)
  end

  def build_permissions(_), do: %{}

  def verify_permissions(conn, required_permissions) do
    %{default: permissions} =
      conn |> Guardian.Plug.current_claims() |> Flagme.Guardian.decode_permissions_from_claims()

    if Enum.all?(permissions, &(&1 in required_permissions)) do
      :ok
    else
      {:error, :unauthorized}
    end
  end
end

defmodule FlagmeWeb.SessionJSON do
  def token(%{access_token: access_token}) do
    %{access_token: access_token}
  end
end

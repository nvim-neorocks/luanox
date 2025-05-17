defmodule LuaNoxWeb.UserOauth do
  use LuaNoxWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    case LuaNox.Accounts.create_user_from_ueberauth(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome #{user.username}")
        |> LuaNoxWeb.UserAuth.log_in_user(user)

      {:error, changeset} ->
        IO.inspect changeset, label: "Error changeset"
        conn
        |> put_flash(:error, "Authentication went through, but failed to create user")
        |> redirect(to: ~p"/")
    end
  end
end

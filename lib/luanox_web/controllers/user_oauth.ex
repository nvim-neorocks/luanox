defmodule LuanoxWeb.UserOauth do
  use LuaNoxWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    user = LuaNoxWeb.Accounts.create_user_from_ueberauth!(auth)

    LuaNoxWeb.UserAuth.log_in_user(conn, user)
  end
end

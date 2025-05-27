defmodule LuaNoxWeb.RevokedKeyController do
  alias LuaNox.RevokedKeys
  use LuaNoxWeb, :controller

  action_fallback LuaNoxWeb.FallbackController

  def create(conn, _attrs) do
    token = LuaNox.Guardian.Plug.current_token(conn)
    scope = LuaNox.Guardian.Plug.current_resource(conn)

    case RevokedKeys.create_revoked_key(scope, %{
           revoked_key: token
         }) do
      {:ok} ->
        send_resp(conn, :ok, "key revoked")

      {:error, _} = err ->
        err
    end
  end
end

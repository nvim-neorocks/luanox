defmodule LuaNoxWeb.UserAuthController do
  use LuaNoxWeb, :controller

  alias LuaNoxWeb.UserAuth

  def log_out_user(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end

defmodule LuanoxWeb.KeyController do
  use LuanoxWeb, :controller

  alias Luanox.Accounts
  alias Luanox.Accounts.Key

  action_fallback LuanoxWeb.FallbackController

  def create(conn, %{"key" => key_params}) do
    with {:ok, %Key{} = key} <- Accounts.create_key(key_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/keys/#{key}")
      |> render(:show, key: key)
    end
  end

  def show(conn, %{"id" => id}) do
    key = Accounts.get_key!(id)
    render(conn, :show, key: key)
  end

  def update(conn, %{"id" => id, "key" => key_params}) do
    key = Accounts.get_key!(id)

    with {:ok, %Key{} = key} <- Accounts.update_key(key, key_params) do
      render(conn, :show, key: key)
    end
  end

  def delete(conn, %{"id" => id}) do
    key = Accounts.get_key!(id)

    with {:ok, %Key{}} <- Accounts.delete_key(key) do
      send_resp(conn, :no_content, "")
    end
  end
end

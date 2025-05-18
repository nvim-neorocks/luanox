defmodule LuaNoxWeb.ReleaseController do
  use LuaNoxWeb, :controller

  alias LuaNox.Packages
  alias LuaNox.Packages.Release

  action_fallback LuaNoxWeb.FallbackController

  def index(conn, _params) do
    releases = Packages.list_releases(conn.assigns.current_scope)
    render(conn, :index, releases: releases)
  end

  def create(conn, %{"release" => release_params}) do
    with {:ok, %Release{} = release} <- Packages.create_release(conn.assigns.current_scope, release_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/releases/#{release}")
      |> render(:show, release: release)
    end
  end

  def show(conn, %{"id" => id}) do
    release = Packages.get_release!(conn.assigns.current_scope, id)
    render(conn, :show, release: release)
  end

  def update(conn, %{"id" => id, "release" => release_params}) do
    release = Packages.get_release!(conn.assigns.current_scope, id)

    with {:ok, %Release{} = release} <- Packages.update_release(conn.assigns.current_scope, release, release_params) do
      render(conn, :show, release: release)
    end
  end

  def delete(conn, %{"id" => id}) do
    release = Packages.get_release!(conn.assigns.current_scope, id)

    with {:ok, %Release{}} <- Packages.delete_release(conn.assigns.current_scope, release) do
      send_resp(conn, :no_content, "")
    end
  end
end

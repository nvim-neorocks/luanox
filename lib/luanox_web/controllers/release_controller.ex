defmodule LuaNoxWeb.ReleaseController do
  use LuaNoxWeb, :controller

  alias LuaNox.Packages.Package
  alias LuaNox.Packages
  alias LuaNox.Packages.Release

  action_fallback LuaNoxWeb.FallbackController

  def index(conn, %{"package" => package_name}) when is_binary(package_name) do
    case Packages.get_package(package_name) do
      nil -> {:error, :not_found}
      package -> render(conn, :index, releases: package.releases)
    end
  end

  def create(conn, %{"package" => package_name, "release" => release_params}) do
    case Packages.get_package(package_name) do
      nil ->
        {:error, :not_found}

      %Package{} = package ->
        case Packages.add_release(conn.assigns.current_scope, package, release_params) do
          {:ok, %Release{} = release} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", ~p"/api/releases/#{release.id}")
            |> render(:show, release: release)

          {:error, _} = ret ->
            ret
        end
    end
  end

  def show(conn, %{"id" => id}) do
    case Packages.get_release(id) do
      nil ->
        {:error, :not_found}

      %Release{} = release ->
        render(conn, :show, release: release)
    end
  end

  def delete(conn, %{"id" => id}) do
    release = Packages.get_release!(id)

    with {:ok, %Release{}} <- Packages.delete_release(conn.assigns.current_scope, release) do
      send_resp(conn, :no_content, "")
    end
  end
end

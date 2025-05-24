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

  def create(
        conn,
        %{
          "package" => package_name,
          "version" => _,
          "rockspec" => %Plug.Upload{} = rockspec
        } = release_params
      ) do
    if Path.extname(rockspec.filename) == ".rockspec" do
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
    else
      {:error, :invalid_rockspec}
    end
  end

  def show(conn, %{"id" => id}) do
    case Packages.get_release(id) do
      nil ->
        {:error, :not_found}

      %Release{} = release ->
        full_file_path =
          Application.app_dir(:luanox, "priv/static/releases/#{release.rockspec_path}")

        conn
        |> put_resp_header(
          "content-disposition",
          "attachment; filename=\"#{release.rockspec_path}\""
        )
        |> put_resp_content_type(MIME.from_path(full_file_path) || "application/octet-stream")
        |> send_file(200, full_file_path)
    end
  end

  def delete(conn, %{"id" => id}) do
    release = Packages.get_release!(id)

    with {:ok, %Release{}} <- Packages.delete_release(conn.assigns.current_scope, release) do
      send_resp(conn, :no_content, "")
    end
  end
end

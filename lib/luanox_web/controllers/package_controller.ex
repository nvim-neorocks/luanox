defmodule LuaNoxWeb.PackageController do
  use LuaNoxWeb, :controller

  alias LuaNox.Packages
  alias LuaNox.Packages.Package

  action_fallback LuaNoxWeb.FallbackController

  def index(conn, %{"query" => query}) when is_binary(query) do
    packages = Packages.list_packages(:exact, query)
    render(conn, :index, packages: packages)
  end

  def index(_conn, _params), do: {:error, :no_query_string}

  def create(conn, %{"package" => package_params}) do
    with {:ok, %Package{} = package} <-
           Packages.create_package(conn.assigns.current_scope, package_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/packages/#{package}")
      |> render(:show, package: package)
    else
      {:error, _} = ret -> ret
    end
  end

  def show(conn, %{"name" => name}) do
    package = Packages.get_package!(name)
    render(conn, :show, package: package)
  end

  def update(conn, %{"name" => name, "package" => package_params}) do
    package = Packages.get_package!(name)

    with {:ok, %Package{} = package} <-
           Packages.update_package(conn.assigns.current_scope, package, package_params) do
      render(conn, :show, package: package)
    else
      {:error, _} = ret -> ret
    end
  end

  # TODO: Do we want to be able to even delete packages?
  def delete(conn, %{"name" => name}) do
    package = Packages.get_package!(name)

    with {:ok, %Package{}} <- Packages.delete_package(conn.assigns.current_scope, package) do
      send_resp(conn, :no_content, "")
    else
      {:error, _} = ret -> ret
    end
  end
end

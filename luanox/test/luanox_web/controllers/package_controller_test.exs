defmodule LuaNoxWeb.PackageControllerTest do
  use LuaNoxWeb.ConnCase

  import LuaNox.PackagesFixtures
  alias LuaNox.Packages.Package

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all packages", %{conn: conn} do
      conn = get(conn, ~p"/api/packages")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create package" do
    test "renders package when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/packages", package: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/packages/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/packages", package: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update package" do
    setup [:create_package]

    test "renders package when data is valid", %{conn: conn, package: %Package{id: id} = package} do
      conn = put(conn, ~p"/api/packages/#{package}", package: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/packages/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, package: package} do
      conn = put(conn, ~p"/api/packages/#{package}", package: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete package" do
    setup [:create_package]

    test "deletes chosen package", %{conn: conn, package: package} do
      conn = delete(conn, ~p"/api/packages/#{package}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/packages/#{package}")
      end
    end
  end

  defp create_package(%{scope: scope}) do
    package = package_fixture(scope)

    %{package: package}
  end
end

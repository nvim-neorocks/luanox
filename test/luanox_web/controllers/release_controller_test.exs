defmodule LuaNoxWeb.ReleaseControllerTest do
  use LuaNoxWeb.ConnCase

  import LuaNox.PackagesFixtures
  alias LuaNox.Packages.Release

  @create_attrs %{
    version: "some version",
    rockspec: "some rockspec"
  }
  @update_attrs %{
    version: "some updated version",
    rockspec: "some updated rockspec"
  }
  @invalid_attrs %{version: nil, rockspec: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all releases", %{conn: conn} do
      conn = get(conn, ~p"/api/releases")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create release" do
    test "renders release when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/releases", release: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/releases/#{id}")

      assert %{
               "id" => ^id,
               "rockspec" => "some rockspec",
               "version" => "some version"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/releases", release: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update release" do
    setup [:create_release]

    test "renders release when data is valid", %{conn: conn, release: %Release{id: id} = release} do
      conn = put(conn, ~p"/api/releases/#{release}", release: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/releases/#{id}")

      assert %{
               "id" => ^id,
               "rockspec" => "some updated rockspec",
               "version" => "some updated version"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, release: release} do
      conn = put(conn, ~p"/api/releases/#{release}", release: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete release" do
    setup [:create_release]

    test "deletes chosen release", %{conn: conn, release: release} do
      conn = delete(conn, ~p"/api/releases/#{release}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/releases/#{release}")
      end
    end
  end

  defp create_release(%{scope: scope}) do
    release = release_fixture(scope)

    %{release: release}
  end
end

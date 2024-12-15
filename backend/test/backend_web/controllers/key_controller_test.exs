defmodule LuanoxWeb.KeyControllerTest do
  use LuanoxWeb.ConnCase

  import Luanox.AccountsFixtures

  alias Luanox.Accounts.Key

  @create_attrs %{
    hash: "some hash"
  }
  @update_attrs %{
    hash: "some updated hash"
  }
  @invalid_attrs %{hash: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all keys", %{conn: conn} do
      conn = get(conn, ~p"/api/keys")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create key" do
    test "renders key when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/keys", key: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/keys/#{id}")

      assert %{
               "id" => ^id,
               "hash" => "some hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/keys", key: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update key" do
    setup [:create_key]

    test "renders key when data is valid", %{conn: conn, key: %Key{id: id} = key} do
      conn = put(conn, ~p"/api/keys/#{key}", key: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/keys/#{id}")

      assert %{
               "id" => ^id,
               "hash" => "some updated hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, key: key} do
      conn = put(conn, ~p"/api/keys/#{key}", key: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete key" do
    setup [:create_key]

    test "deletes chosen key", %{conn: conn, key: key} do
      conn = delete(conn, ~p"/api/keys/#{key}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/keys/#{key}")
      end
    end
  end

  defp create_key(_) do
    key = key_fixture()
    %{key: key}
  end
end

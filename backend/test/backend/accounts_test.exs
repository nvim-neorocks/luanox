defmodule Luanox.AccountsTest do
  use Luanox.DataCase

  alias Luanox.Accounts

  describe "keys" do
    alias Luanox.Accounts.Key

    import Luanox.AccountsFixtures

    @invalid_attrs %{hash: nil}

    test "list_keys/0 returns all keys" do
      key = key_fixture()
      assert Accounts.list_keys() == [key]
    end

    test "get_key!/1 returns the key with given id" do
      key = key_fixture()
      assert Accounts.get_key!(key.id) == key
    end

    test "create_key/1 with valid data creates a key" do
      valid_attrs = %{hash: "some hash"}

      assert {:ok, %Key{} = key} = Accounts.create_key(valid_attrs)
      assert key.hash == "some hash"
    end

    test "create_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_key(@invalid_attrs)
    end

    test "update_key/2 with valid data updates the key" do
      key = key_fixture()
      update_attrs = %{hash: "some updated hash"}

      assert {:ok, %Key{} = key} = Accounts.update_key(key, update_attrs)
      assert key.hash == "some updated hash"
    end

    test "update_key/2 with invalid data returns error changeset" do
      key = key_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_key(key, @invalid_attrs)
      assert key == Accounts.get_key!(key.id)
    end

    test "delete_key/1 deletes the key" do
      key = key_fixture()
      assert {:ok, %Key{}} = Accounts.delete_key(key)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_key!(key.id) end
    end

    test "change_key/1 returns a key changeset" do
      key = key_fixture()
      assert %Ecto.Changeset{} = Accounts.change_key(key)
    end
  end

  describe "users" do
    alias Luanox.Accounts.User

    import Luanox.AccountsFixtures

    @invalid_attrs %{aka: nil, platform: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{aka: "some aka", platform: :github, username: "some username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.aka == "some aka"
      assert user.platform == :github
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{aka: "some updated aka", platform: :gitlab, username: "some updated username"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.aka == "some updated aka"
      assert user.platform == :gitlab
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

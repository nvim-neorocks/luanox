defmodule LuaNox.RevokedKeysTest do
  use LuaNox.DataCase

  alias LuaNox.RevokedKeys

  describe "revoked_keys" do
    alias LuaNox.RevokedKeys.RevokedKey

    import LuaNox.AccountsFixtures, only: [user_scope_fixture: 0]
    import LuaNox.RevokedKeysFixtures

    @invalid_attrs %{hashed_revoked_key: nil}

    test "list_revoked_keys/1 returns all scoped revoked_keys" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)
      other_revoked_key = revoked_key_fixture(other_scope)
      assert RevokedKeys.list_revoked_keys(scope) == [revoked_key]
      assert RevokedKeys.list_revoked_keys(other_scope) == [other_revoked_key]
    end

    test "get_revoked_key!/2 returns the revoked_key with given id" do
      scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)
      other_scope = user_scope_fixture()
      assert RevokedKeys.get_revoked_key!(scope, revoked_key.id) == revoked_key

      assert_raise Ecto.NoResultsError, fn ->
        RevokedKeys.get_revoked_key!(other_scope, revoked_key.id)
      end
    end

    test "create_revoked_key/2 with valid data creates a revoked_key" do
      valid_attrs = %{hashed_revoked_key: "some hashed_revoked_key"}
      scope = user_scope_fixture()

      assert {:ok, %RevokedKey{} = revoked_key} =
               RevokedKeys.create_revoked_key(scope, valid_attrs)

      assert revoked_key.hashed_revoked_key == "some hashed_revoked_key"
      assert revoked_key.user_id == scope.user.id
    end

    test "create_revoked_key/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = RevokedKeys.create_revoked_key(scope, @invalid_attrs)
    end

    test "update_revoked_key/3 with valid data updates the revoked_key" do
      scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)
      update_attrs = %{hashed_revoked_key: "some updated hashed_revoked_key"}

      assert {:ok, %RevokedKey{} = revoked_key} =
               RevokedKeys.update_revoked_key(scope, revoked_key, update_attrs)

      assert revoked_key.hashed_revoked_key == "some updated hashed_revoked_key"
    end

    test "update_revoked_key/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)

      assert_raise MatchError, fn ->
        RevokedKeys.update_revoked_key(other_scope, revoked_key, %{})
      end
    end

    test "update_revoked_key/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               RevokedKeys.update_revoked_key(scope, revoked_key, @invalid_attrs)

      assert revoked_key == RevokedKeys.get_revoked_key!(scope, revoked_key.id)
    end

    test "delete_revoked_key/2 deletes the revoked_key" do
      scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)
      assert {:ok, %RevokedKey{}} = RevokedKeys.delete_revoked_key(scope, revoked_key)

      assert_raise Ecto.NoResultsError, fn ->
        RevokedKeys.get_revoked_key!(scope, revoked_key.id)
      end
    end

    test "delete_revoked_key/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)
      assert_raise MatchError, fn -> RevokedKeys.delete_revoked_key(other_scope, revoked_key) end
    end

    test "change_revoked_key/2 returns a revoked_key changeset" do
      scope = user_scope_fixture()
      revoked_key = revoked_key_fixture(scope)
      assert %Ecto.Changeset{} = RevokedKeys.change_revoked_key(scope, revoked_key)
    end
  end
end

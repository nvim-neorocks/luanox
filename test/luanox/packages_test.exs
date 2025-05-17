defmodule LuaNox.PackagesTest do
  use LuaNox.DataCase

  alias LuaNox.Packages

  describe "packages" do
    alias LuaNox.Packages.Package

    import LuaNox.AccountsFixtures, only: [user_scope_fixture: 0]
    import LuaNox.PackagesFixtures

    @invalid_attrs %{name: nil}

    test "list_packages/1 returns all scoped packages" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      package = package_fixture(scope)
      other_package = package_fixture(other_scope)
      assert Packages.list_packages(scope) == [package]
      assert Packages.list_packages(other_scope) == [other_package]
    end

    test "get_package!/2 returns the package with given id" do
      scope = user_scope_fixture()
      package = package_fixture(scope)
      other_scope = user_scope_fixture()
      assert Packages.get_package!(scope, package.id) == package
      assert_raise Ecto.NoResultsError, fn -> Packages.get_package!(other_scope, package.id) end
    end

    test "create_package/2 with valid data creates a package" do
      valid_attrs = %{name: "some name"}
      scope = user_scope_fixture()

      assert {:ok, %Package{} = package} = Packages.create_package(scope, valid_attrs)
      assert package.name == "some name"
      assert package.user_id == scope.user.id
    end

    test "create_package/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Packages.create_package(scope, @invalid_attrs)
    end

    test "update_package/3 with valid data updates the package" do
      scope = user_scope_fixture()
      package = package_fixture(scope)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Package{} = package} = Packages.update_package(scope, package, update_attrs)
      assert package.name == "some updated name"
    end

    test "update_package/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      package = package_fixture(scope)

      assert_raise MatchError, fn ->
        Packages.update_package(other_scope, package, %{})
      end
    end

    test "update_package/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      package = package_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Packages.update_package(scope, package, @invalid_attrs)
      assert package == Packages.get_package!(scope, package.id)
    end

    test "delete_package/2 deletes the package" do
      scope = user_scope_fixture()
      package = package_fixture(scope)
      assert {:ok, %Package{}} = Packages.delete_package(scope, package)
      assert_raise Ecto.NoResultsError, fn -> Packages.get_package!(scope, package.id) end
    end

    test "delete_package/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      package = package_fixture(scope)
      assert_raise MatchError, fn -> Packages.delete_package(other_scope, package) end
    end

    test "change_package/2 returns a package changeset" do
      scope = user_scope_fixture()
      package = package_fixture(scope)
      assert %Ecto.Changeset{} = Packages.change_package(scope, package)
    end
  end

  describe "releases" do
    alias LuaNox.Packages.Release

    import LuaNox.AccountsFixtures, only: [user_scope_fixture: 0]
    import LuaNox.PackagesFixtures

    @invalid_attrs %{version: nil, rockspec: nil}

    test "list_releases/1 returns all scoped releases" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      release = release_fixture(scope)
      other_release = release_fixture(other_scope)
      assert Packages.list_releases(scope) == [release]
      assert Packages.list_releases(other_scope) == [other_release]
    end

    test "get_release!/2 returns the release with given id" do
      scope = user_scope_fixture()
      release = release_fixture(scope)
      other_scope = user_scope_fixture()
      assert Packages.get_release!(scope, release.id) == release
      assert_raise Ecto.NoResultsError, fn -> Packages.get_release!(other_scope, release.id) end
    end

    test "create_release/2 with valid data creates a release" do
      valid_attrs = %{version: "some version", rockspec: "some rockspec"}
      scope = user_scope_fixture()

      assert {:ok, %Release{} = release} = Packages.create_release(scope, valid_attrs)
      assert release.version == "some version"
      assert release.rockspec == "some rockspec"
      assert release.user_id == scope.user.id
    end

    test "create_release/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Packages.create_release(scope, @invalid_attrs)
    end

    test "update_release/3 with valid data updates the release" do
      scope = user_scope_fixture()
      release = release_fixture(scope)
      update_attrs = %{version: "some updated version", rockspec: "some updated rockspec"}

      assert {:ok, %Release{} = release} = Packages.update_release(scope, release, update_attrs)
      assert release.version == "some updated version"
      assert release.rockspec == "some updated rockspec"
    end

    test "update_release/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      release = release_fixture(scope)

      assert_raise MatchError, fn ->
        Packages.update_release(other_scope, release, %{})
      end
    end

    test "update_release/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      release = release_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Packages.update_release(scope, release, @invalid_attrs)
      assert release == Packages.get_release!(scope, release.id)
    end

    test "delete_release/2 deletes the release" do
      scope = user_scope_fixture()
      release = release_fixture(scope)
      assert {:ok, %Release{}} = Packages.delete_release(scope, release)
      assert_raise Ecto.NoResultsError, fn -> Packages.get_release!(scope, release.id) end
    end

    test "delete_release/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      release = release_fixture(scope)
      assert_raise MatchError, fn -> Packages.delete_release(other_scope, release) end
    end

    test "change_release/2 returns a release changeset" do
      scope = user_scope_fixture()
      release = release_fixture(scope)
      assert %Ecto.Changeset{} = Packages.change_release(scope, release)
    end
  end
end

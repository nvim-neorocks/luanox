defmodule LuaNox.PackagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LuaNox.Packages` context.
  """

  @doc """
  Generate a package.
  """
  def package_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name"
      })

    {:ok, package} = LuaNox.Packages.create_package(scope, attrs)
    package
  end

  @doc """
  Generate a release.
  """
  def release_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        rockspec: "some rockspec",
        version: "some version"
      })

    {:ok, release} = LuaNox.Packages.create_release(scope, attrs)
    release
  end
end

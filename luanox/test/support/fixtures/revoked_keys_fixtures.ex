defmodule LuaNox.RevokedKeysFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LuaNox.RevokedKeys` context.
  """

  @doc """
  Generate a revoked_key.
  """
  def revoked_key_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        hashed_revoked_key: "some hashed_revoked_key"
      })

    {:ok, revoked_key} = LuaNox.RevokedKeys.create_revoked_key(scope, attrs)
    revoked_key
  end
end

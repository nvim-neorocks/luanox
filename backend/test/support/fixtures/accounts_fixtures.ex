defmodule Luanox.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Luanox.Accounts` context.
  """

  @doc """
  Generate a unique key hash.
  """
  def unique_key_hash, do: "some hash#{System.unique_integer([:positive])}"

  @doc """
  Generate a key.
  """
  def key_fixture(attrs \\ %{}) do
    {:ok, key} =
      attrs
      |> Enum.into(%{
        hash: unique_key_hash()
      })
      |> Luanox.Accounts.create_key()

    key
  end

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        aka: "some aka",
        platform: :github,
        username: unique_user_username()
      })
      |> Luanox.Accounts.create_user()

    user
  end
end

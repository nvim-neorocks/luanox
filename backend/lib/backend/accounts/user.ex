defmodule Luanox.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :aka, :string
    field :platform, Ecto.Enum, values: [:github, :gitlab, :codeberg]
    field :username, :string
    field :keys, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :aka, :platform])
    |> validate_required([:username, :aka, :platform])
    |> unique_constraint(:username)
  end
end

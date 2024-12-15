defmodule Luanox.Accounts.Key do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keys" do
    field :hash, :string, redact: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(key, attrs) do
    key
    |> cast(attrs, [:hash])
    |> validate_required([:hash])
    |> unique_constraint(:hash)
  end
end

defmodule LuaNox.Packages.Package do
  alias LuaNox.Accounts.Scope
  use Ecto.Schema
  import Ecto.Changeset

  schema "packages" do
    field :name, :string
    field :summary, :string
    field :description, :string
    belongs_to :user, LuaNox.Accounts.User
    has_many :releases, LuaNox.Packages.Release

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(package, attrs, %Scope{} = user_scope) do
    package
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    # Recast here to prevent the user from changing the package name
    |> cast(attrs, [:summary, :description])
    |> validate_length(:name, min: 1, max: 20)
    |> validate_length(:summary, min: 1, max: 100)
    |> validate_length(:description, max: 9999)
    |> put_change(:user_id, user_scope.user.id)
  end
end

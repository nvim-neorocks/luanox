defmodule LuaNox.Packages.Release do
  use Ecto.Schema
  import Ecto.Changeset

  schema "releases" do
    field :version, :string
    field :rockspec, :string
    belongs_to :package, LuaNox.Packages.Package

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(release, attrs) do
    # TODO: In the future verify that the rockspec is valid
    release
    |> cast(attrs, [:version, :rockspec])
    |> validate_required([:version, :rockspec])
    |> unique_constraint([:version, :package_id], name: :unique_package_version)
    |> validate_format(:version, ~r/^\d+(\.\d+){2}$/)
  end
end

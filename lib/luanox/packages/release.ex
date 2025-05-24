defmodule LuaNox.Packages.Release do
  alias LuaNox.Packages
  use Ecto.Schema
  import Ecto.Changeset
  import Logger, only: :macros

  schema "releases" do
    field :version, :string
    field :rockspec_path, :string
    field :rockspec, :any, virtual: true
    belongs_to :package, LuaNox.Packages.Package

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(release, attrs) do
    release
    |> cast(attrs, [:version, :rockspec])
    |> validate_required([:version, :rockspec])
    |> unique_constraint([:version, :package_id], name: :unique_package_version)
    |> validate_format(:version, ~r/^\d+(\.\d+){2}\-\d+$/)
    |> validate_rockspec(attrs["package"])
  end

  defp validate_rockspec(changeset, package) do
    rockspec = get_field(changeset, :rockspec)
    version = get_field(changeset, :version)

    case Application.get_env(:luanox, :rockspec_verification_endpoint)
         |> Req.post(json: %{rockspec: rockspec, package: package, version: version}) do
      {:ok, %Req.Response{status: 200}} ->
        changeset
        |> put_change(:rockspec_path, "#{package}-#{version}.rockspec")

      {:ok, %Req.Response{status: 400, body: %{"error" => "Invalid parameters"}}} ->
        Logger.error("Invalid parameters provided to rockspec verification endpoint",
          rockspec: rockspec
        )

        add_error(changeset, :rockspec, "Invalid rockspec")

      {:ok, %Req.Response{status: 422}} ->
        add_error(changeset, :rockspec, "Invalid rockspec")
    end
  end
end

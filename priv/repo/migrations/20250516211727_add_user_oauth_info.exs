defmodule LuaNox.Repo.Migrations.AddUserOauthInfo do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :provider, :string
      add :username, :string
      add :aka, :string
    end

    create unique_index(:users, [:provider, :username])
  end
end

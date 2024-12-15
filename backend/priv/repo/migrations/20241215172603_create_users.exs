defmodule Luanox.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :text
      add :aka, :string
      add :platform, :string
      add :keys, references(:keys, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
    create index(:users, [:keys])
  end
end

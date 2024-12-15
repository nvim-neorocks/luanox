defmodule Luanox.Repo.Migrations.CreateKeys do
  use Ecto.Migration

  def change do
    create table(:keys) do
      add :hash, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:keys, [:hash])
  end
end

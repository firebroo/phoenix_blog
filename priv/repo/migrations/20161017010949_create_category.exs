defmodule HelloPhoenix.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categorys) do
      add :name, :string

      timestamps()
    end
    create unique_index(:categorys, [:name])
  end
end

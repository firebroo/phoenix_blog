defmodule HelloPhoenix.Repo.Migrations.CreateLink do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :name, :string
      add :url, :string

      timestamps()
    end

  end
end

defmodule HelloPhoenix.Repo.Migrations.AddHashIdToArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
        add :hash_id, :string
    end
  end
end

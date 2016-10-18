defmodule HelloPhoenix.Repo.Migrations.AddReadingToArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
        add :reading, :integer, default: 0
    end
  end
end

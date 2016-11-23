defmodule HelloPhoenix.Repo.Migrations.AddBlockToArticleTable do
  use Ecto.Migration

  def change do
    alter table(:articles) do
        add :block, :boolean, default: false
    end
  end
end

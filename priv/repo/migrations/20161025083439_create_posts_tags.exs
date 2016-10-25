defmodule HelloPhoenix.Repo.Migrations.CreatePostsTags do
  use Ecto.Migration

  def change do
    create table(:posts_tags, primary_key: false) do
      add :article_id, references(:articles)
      add :tag_id, references(:tags)
    end
  end
end

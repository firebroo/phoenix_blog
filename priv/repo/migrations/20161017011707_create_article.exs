defmodule HelloPhoenix.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :body, :text
      add :category_id, references(:categorys, on_delete: :nothing)

      timestamps()
    end
    create index(:articles, [:category_id])

  end
end

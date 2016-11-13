defmodule HelloPhoenix.Repo.Migrations.AddHashIdToCategory do
  use Ecto.Migration

  def change do
    alter table(:categorys) do
        add :hash_id, :string
    end
  end
end

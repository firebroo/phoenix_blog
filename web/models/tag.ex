defmodule HelloPhoenix.Tag do
  use HelloPhoenix.Web, :model

  schema "tags" do
    field :name, :string
    many_to_many :articles, HelloPhoenix.Article, join_through: "posts_tags", on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

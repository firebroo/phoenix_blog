defmodule HelloPhoenix.Category do
  use HelloPhoenix.Web, :model

  schema "categorys" do
    field :name, :string, unique: true
    has_many :articles, HelloPhoenix.Article, on_delete: :delete_all

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

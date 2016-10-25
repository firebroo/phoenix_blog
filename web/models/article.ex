defmodule HelloPhoenix.Article do
  use HelloPhoenix.Web, :model

  schema "articles" do
    field :title, :string
    field :body, :string
    field :reading, :integer, default: 0
    belongs_to :category, HelloPhoenix.Category, foreign_key: :category_id

    has_many :comments, HelloPhoenix.Comment, on_delete: :delete_all
    many_to_many :tags, HelloPhoenix.Tag, join_through: "posts_tags"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :reading, :category_id])
    |> validate_required([:title, :body])
    |> validate_length(:title, min: 5)
    |> unique_constraint(:title)
  end
end

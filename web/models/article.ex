defmodule HelloPhoenix.Article do
  use HelloPhoenix.Web, :model

  schema "articles" do
    field :title, :string
    field :body, :string
    field :reading, :integer, default: 0
    field :hash_id, :string
    field :block, :boolean, default: false
    belongs_to :category, HelloPhoenix.Category, foreign_key: :category_id

    has_many :comments, HelloPhoenix.Comment, on_delete: :delete_all
    many_to_many :tags, HelloPhoenix.Tag, join_through: "posts_tags", on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :reading, :category_id, :block])
    |> validate_required([:title, :body, :category_id])
    #|> strip_unsafe_body(params)
    |> validate_length(:title, min: 5)
    |> unique_constraint(:title)
  end

  @doc """
  添加hash之后的id
  """
  def put_id_hash(%Ecto.Changeset{valid?: false} = changeset, _field1, _filed2) do
     changeset
  end

  def put_id_hash(%Ecto.Changeset{valid?: true} = changeset, field1, filed2) do
    value = get_field(changeset, field1) <> get_field(changeset, filed2)
    changeset |> put_change(:hash_id, :crypto.hash(:sha256, value) |> Base.encode16 |> String.downcase)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :reading, :category_id, :block])
    |> validate_required([:title, :body, :category_id])
    #|> strip_unsafe_body(params)
    |> validate_length(:title, min: 5)
    |> unique_constraint(:title)
    |> put_id_hash(:title, :body)
  end

  defp strip_unsafe_body(model, %{"body" => nil}) do
    model
  end
    
  defp strip_unsafe_body(model, %{"body" => body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    model |> put_change(:body, clean_body)
  end
    
  defp strip_unsafe_body(model, _) do
    model
  end
end

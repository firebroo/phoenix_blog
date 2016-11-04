defmodule HelloPhoenix.Article do
  use HelloPhoenix.Web, :model

  schema "articles" do
    field :title, :string
    field :body, :string
    field :reading, :integer, default: 0
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
    |> cast(params, [:title, :body, :reading, :category_id])
    |> validate_required([:title, :body, :category_id])
    #|> strip_unsafe_body(params)
    |> validate_length(:title, min: 5)
    |> unique_constraint(:title)
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

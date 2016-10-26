defmodule HelloPhoenix.ArticleTag do
  use HelloPhoenix.Web, :model

  schema "posts_tags" do
    field :article_id, :integer
    field :tag_id, :integer
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:article_id, :tag_id])
  end
end

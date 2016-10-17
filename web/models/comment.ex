defmodule HelloPhoenix.Comment do
  use HelloPhoenix.Web, :model

  schema "comments" do
    field :name, :string
    field :body, :string
    belongs_to :article, HelloPhoenix.Article

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :body, :article_id])
    |> validate_required([:name, :body])
  end
end

defmodule HelloPhoenix.Category do
  use HelloPhoenix.Web, :model

  schema "categorys" do
    field :name, :string, unique: true
    field :hash_id, :string
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

  @doc """
  添加hash之后的id
  """
  def put_id_hash(%Ecto.Changeset{valid?: false} = changeset, _field) do
     changeset
  end

  def put_id_hash(%Ecto.Changeset{valid?: true} = changeset, field) do
    value = get_field(changeset, field)
    changeset |> put_change(:hash_id, :crypto.hash(:sha256, value) |> Base.encode16 |> String.downcase)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> put_id_hash(:name)
  end
end

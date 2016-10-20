defmodule HelloPhoenix.User do
  use HelloPhoenix.Web, :model

  alias Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :name, :string
    field :password, :string

    field :password_confirmation, :string, virtual: true
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password])
    |> validate_required([:name, :password])
    |> unique_constraint(:name)
  end

  def put_password_hash(%Ecto.Changeset{valid?: true} = changeset, field) do
    value = get_field(changeset, field)
    
    changeset |> put_change(:password, Comeonin.Bcrypt.hashpwsalt(value))
  end
      
  def put_password_hash(%Ecto.Changeset{valid?: false} = changeset, _field) do
     changeset
  end

  def changeset_register(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password, :password_confirmation])
    |> validate_required([:name, :password, :password_confirmation], message: "字段不能为空")
    |> validate_length(:password, min: 6, message: "密码长度不能小于6位")
    |> validate_confirmation(:password, message: "两次密码输入不一致")
    |> unique_constraint(:name, message: "用户名已经被注册")
    |> put_password_hash(:password)
  end

end

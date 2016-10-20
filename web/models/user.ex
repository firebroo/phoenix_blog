defmodule HelloPhoenix.User do
  use HelloPhoenix.Web, :model

  alias HelloPhoenix.Repo

  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]

  schema "users" do
    field :name, :string
    field :password, :string
    field :avatar, :string

    field :old_password, :string, virtual: true
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

  def changeset_avatar(struct, params \\ %{}) do
    struct
    |> cast(params, [:avatar])
    |> validate_required([:avatar])
  end

  @doc """
  将密码加密
  """
  def put_password_hash(%Ecto.Changeset{valid?: false} = changeset, _field) do
     changeset
  end

  def put_password_hash(%Ecto.Changeset{valid?: true} = changeset, field) do
    value = get_field(changeset, field)
    
    changeset |> put_change(:password, hashpwsalt(value))
  end

  @doc """
  验证用户是否存在
  """
  def validate_user_exist(%Ecto.Changeset{valid?: false} = changeset, _field) do
    changeset
  end

  def validate_user_exist(%Ecto.Changeset{valid?: true} = changeset, field) do
    value = get_field(changeset, field)

    user = __MODULE__ |> Repo.get_by(name: value)

    case user do
      nil ->
        changeset
        |> add_error(field, "用户不存在")
      user ->
        changeset
        |> put_change(:user, user)
    end
  end

  @doc """
  验证密码是否正确
  """
  def validate_password(%Ecto.Changeset{valid?: false} = changeset, _field) do
    changeset
  end

  def validate_password(%Ecto.Changeset{valid?: true} = changeset, field) do
    user = get_field(changeset, :user) || changeset.data
    password = get_field(changeset, field)

    case check_password?(password, user.password) do
      true ->
        changeset
      false ->
        changeset
        |> add_error(field, "密码错误")
    end
  end

  def check_password?(password, password_hash) do
    checkpw(password, password_hash)
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

  def changeset_reset_password(struct, params \\ %{}) do
    struct
    |> cast(params, [:old_password, :password, :password_confirmation])
    |> validate_required([:old_password, :password, :password_confirmation], message: "字段不能为空")
    |> validate_length(:password, min: 6, message: "新密码长度不能小于6位")
    |> validate_confirmation(:password, message: "两次密码输入不一致")
    |> validate_password(:old_password)
    |> put_password_hash(:password)
  end

  def changeset_login(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_user_exist(:name)
    |> validate_password(:password)
  end

end

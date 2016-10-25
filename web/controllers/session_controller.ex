defmodule HelloPhoenix.SessionController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User}
  @allow_file_suffix [".gif", ".jpg", ".jpeg", ".png", ".svg"]
  import Ecto.Changeset, only: [add_error: 4]
  
  def new(conn, _params) do
    changeset = User.changeset(%User{})
    conn
    |> assign(:changeset, changeset)
    |> render("new.html")
  end
  
  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, name: user_params["name"])
    changeset = User.changeset_login(%User{}, user_params)

    #checkd = case user do
    #      nil -> false # 用户不存在
    #      _   -> case checkpw(password, user.password) do
    #             true -> true
    #             _    -> false # 密码错误
    #             end
    #    end

    case changeset.valid? do
      true ->
        conn
        |> put_flash(:info, "登陆成功")
        |> put_session(:user_id, user.id)
        |> put_session(:username, user.name)
        |> redirect(to: user_session_path(conn, :home))
      false -> 
        conn
        |> assign(:changeset, changeset)
        |> put_flash(:error, "登陆失败")
        |> render("new.html")
    end
  end

  def home(conn, _params) do
    user = Repo.get!(User, get_session(conn, :user_id)) 

    conn
    |> assign(:username, get_session(conn, :username))
    |> assign(:avatar, user.avatar)
    |> render("home.html")
  end

  def new_avatar(conn, _params) do
    changeset = User.changeset(%User{})

    conn
    |> assign(:changeset, changeset)
    |> render("photo_form.html")
  end

  def update_avatar(conn, %{"user" => user_params}) do
    user_id = get_session(conn, :user_id)
    if upload = user_params["avatar"] do
      extension = Path.extname(upload.filename)
      path = "priv/static/images/#{user_id}-profile#{extension}"
      
      changeset = User.changeset_avatar(%User{})
      case extension in @allow_file_suffix do
        true ->
          case File.cp(upload.path, path) do
            :ok ->  # 上传成功, 将图片地址入库
              User
              |> Repo.get!(user_id)
              |> User.changeset_avatar(%{"avatar" => "/images/#{user_id}-profile#{extension}"})
              |> Repo.update!

              conn
              |> put_flash(:info, "修改头像成功")
              |> redirect(to: user_session_path(conn, :home))
            {:error, _} ->
              changeset = changeset |> add_error(:avatar, "上传出错", message: "上传出错")
          end
        false ->
          changeset = changeset |> add_error(:avatar, "不允许的后缀", message: "不允许的后缀")
      end
      conn
      |> assign(:changeset, changeset)
      |> put_flash(:error, "修改头像失败")
      |> render("photo_form.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> delete_session(:username)
    |> redirect(to: session_path(conn, :new))
  end
end

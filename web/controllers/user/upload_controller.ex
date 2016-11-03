defmodule HelloPhoenix.User.UploadController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User}
  @allow_file_suffix [".gif", ".jpg", ".jpeg", ".png", ".svg"]
  import Ecto.Changeset, only: [add_error: 4]
  
  def new_avatar(conn, _params) do
    user = Repo.get!(User, get_session(conn, :user_id))
    changeset = User.changeset(%User{})

    conn
    |> assign(:changeset, changeset)
    |> assign(:avatar, user.avatar)
    |> render("photo_form.html")
  end

  def update_avatar(conn, %{"user" => user_params}) do
    user_id = get_session(conn, :user_id)
    if upload = user_params["avatar"] do
      extension = Path.extname(upload.filename)
      path = "priv/static/images/#{user_id}-profile#{extension}"
      
      changeset = User.changeset_avatar(%User{})
      user = Repo.get!(User, get_session(conn, :user_id))
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
              |> assign(:changeset, changeset)
              |> redirect(to: user_profile_path(conn, :show))
            {:error, _} ->
              changeset = changeset |> add_error(:avatar, "上传出错", message: "上传出错")

              conn
              |> assign(:avatar, user.avatar)
              |> assign(:changeset, changeset)
              |> put_flash(:error, "修改头像失败")
              |> redirect(to: user_profile_path(conn, :show))
          end
        false ->
          changeset = changeset |> add_error(:avatar, "不允许的后缀", message: "不允许的后缀")

          conn
          |> assign(:avatar, user.avatar)
          |> assign(:changeset, changeset)
          |> put_flash(:error, "修改头像失败")
          |> redirect(to: user_profile_path(conn, :show))
      end
    end
  end
end

defmodule HelloPhoenix.UserController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User}
  alias HelloPhoenix.Router.Helpers

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
     changeset = User.changeset_register(%User{}, user_params)

     case Repo.insert(changeset) do
       {:ok, _user} ->
         conn
         |> put_flash(:info, "创建用户成功,请登陆")
         |> redirect(to: Helpers.session_path(conn, :new))
       {:error, changeset} ->
         conn
         |> assign(:changeset, changeset)
         |> render("new.html")
     end
  end

  def edit(conn, _params) do
   changeset = User
   |> Repo.get!(get_session(conn, :user_id))
   |> User.changeset

    conn
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"user" => user_params}) do
    changeset = User
    |> Repo.get!(get_session(conn, :user_id))
    |> User.changeset_reset_password(user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "密码修改成功")
        |> redirect(to: Helpers.user_session_path(conn, :home))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end

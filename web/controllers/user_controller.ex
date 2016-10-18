defmodule HelloPhoenix.UserController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User}
  alias HelloPhoenix.Router.Helpers

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
     changeset = User.changeset(%User{}, user_params) 

     case Repo.insert(changeset) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "创建用户成功")
          |> redirect(to: Helpers.session_path(conn, :new))
        {:error, changset} ->
          conn
          |> put_flash(:error, "创建用户失败")
          |> assign(:changeset, changeset)
          |> render("new.html")
     end
  end
end

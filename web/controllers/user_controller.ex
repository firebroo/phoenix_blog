defmodule HelloPhoenix.UserController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User}
  alias HelloPhoenix.Router.Helpers

  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
     changeset = User.changeset(%User{}, user_params)
     |> put_change(:password, hashpwsalt(user_params["password"])) 

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
end

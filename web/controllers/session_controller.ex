defmodule HelloPhoenix.SessionController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User}
  
  def new(conn, _params) do
    changeset = User.changeset(%User{})
    conn
    |> assign(:changeset, changeset)
    |> render("new.html")
  end
  
  def create(conn, %{"user" => %{"name" => name, "password" => password}}) do
    user = User
    |> Repo.get_by!(name: name)
    
    if user.password == password do
      conn
      |> put_flash(:info, "登陆成功")
      |> put_session(:user_id, user.id)
      |> put_session(:username, user.name)
      |> redirect(to: user_session_path(conn, :home))
    end

    changeset = User.changeset(%User{})
    conn
    |> assign(:changeset, changeset)
    |> put_flash(:error, "登陆失败")
    |> render("new.html")
  end

  def home(conn, _params) do
    conn
    |> assign(:username, get_session(conn, :username))
    |> render("home.html")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> delete_session(:username)
    |> redirect(to: session_path(conn, :new))
  end
end

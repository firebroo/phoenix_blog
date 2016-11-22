defmodule HelloPhoenix.SessionController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User, Article}
  
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
    articles = Article
    |> Repo.all
    |> Repo.preload(:category)

    conn
    |> assign(:username, get_session(conn, :username))
    |> assign(:avatar, user.avatar)
    |> assign(:articles, articles)
    |> render("home.html")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> delete_session(:username)
    |> redirect(to: session_path(conn, :new))
  end
end

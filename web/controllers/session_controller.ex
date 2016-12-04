defmodule HelloPhoenix.SessionController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{User, Article, Link, Category, Comment, Tag}
  
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
        |> put_session(:user_avatar, user.avatar)
        |> put_session(:username, user.name)
        |> redirect(to: user_session_path(conn, :home))
      false -> 
        conn
        |> assign(:changeset, changeset)
        |> put_flash(:error, "登陆失败,用户或者密码错误。")
        |> render("new.html")
    end
  end

  def home(conn, _params) do
    user = Repo.get!(User, get_session(conn, :user_id)) 
    article_count = from(a in Article, select: count(a.id)) |> Repo.one
    tag_count = from(t in Tag, select: count(t.id)) |> Repo.one
    link_count = from(l in Link, select: count(l.id)) |> Repo.one
    comment_count = from(cm in Comment, select: count(cm.id)) |> Repo.one
    category_count = from(cg in Category, select: count(cg.id)) |> Repo.one

    conn
    |> assign(:username, get_session(conn, :username))
    |> assign(:avatar, user.avatar)
    |> assign(:article_count, article_count)
    |> assign(:link_count, link_count)
    |> assign(:tag_count, tag_count)
    |> assign(:category_count, category_count)
    |> assign(:comment_count, comment_count)
    |> render("home.html")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> delete_session(:username)
    |> delete_session(:user_avatar)
    |> put_flash(:info, "退出成功。") 
    |> redirect(to: session_path(conn, :new))
  end
end

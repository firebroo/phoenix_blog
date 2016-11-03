defmodule HelloPhoenix.User.ProfileController do
  use HelloPhoenix.Web, :controller
    
  alias HelloPhoenix.{User}

  def show(conn, _params) do
    user = Repo.get!(User, get_session(conn, :user_id))
    changeset = User.changeset(%User{})

    passwd_changeset = User
    |> Repo.get!(get_session(conn, :user_id))
    |> User.changeset

    conn
    |> assign(:changeset, changeset)
    |> assign(:passwd_changeset, passwd_changeset)
    |> assign(:avatar, user.avatar)
    |> render(:show)
  end

end

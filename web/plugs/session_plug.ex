defmodule HelloPhoenix.Plugs.Session do

  import Plug.Conn
  import Phoenix.Controller, [:redirect]

  alias HelloPhoenix.Router.Helpers

  def init(default), do: default

  def call(conn, _params) do
    if get_session(conn, :user_id) == nil do
      conn 
      |> redirect(to: Helpers.session_path(conn, :new))
    end
    conn
  end

end

defmodule HelloPhoenix.Plugs.Session do

  import Plug.Conn, only: [get_session: 2, halt: 1]
  import Phoenix.Controller, only: [redirect: 2]
  alias HelloPhoenix.Router.Helpers

  def init(default), do: default

  def call(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        conn |> redirect(to: Helpers.session_path(conn, :new)) |> halt
      _  -> 
        conn
    end
  end

end

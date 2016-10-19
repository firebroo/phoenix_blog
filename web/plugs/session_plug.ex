defmodule HelloPhoenix.Plugs.Session do

  import Plug.Conn, only: [get_session: 2, halt: 1]
  import Phoenix.Controller, only: [redirect: 2]

  def init(default), do: default

  def call(conn, _params) do
    if get_session(conn, :user_id) == nil do
      conn |> redirect(to: "/users/login") |> halt
    end
  end

end

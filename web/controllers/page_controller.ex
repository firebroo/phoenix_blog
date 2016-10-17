defmodule HelloPhoenix.PageController do
    use HelloPhoenix.Web, :controller

    def index(conn, _params) do
        conn
        |> render("index.html")
    end

    def show(conn, %{"id" => id}) do
        json conn, %{id: id}
    end
end

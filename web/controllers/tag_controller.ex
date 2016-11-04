defmodule HelloPhoenix.TagController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Tag

  def show(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    render(conn, "show.html", tag: tag)
  end
end

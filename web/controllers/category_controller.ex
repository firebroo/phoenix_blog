defmodule HelloPhoenix.CategoryController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Category

  def index(conn, _params) do
    categorys = Repo.all(Category)
    render(conn, "index.html", categorys: categorys)
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.html", category: category)
  end

end

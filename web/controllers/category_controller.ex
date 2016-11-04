defmodule HelloPhoenix.CategoryController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{Category, Article}

  def index(conn, _params) do
    categorys = Repo.all(Category)
    articles = Article
    |> Repo.all
    |> Repo.preload([:category, :tags])

    conn
    |> assign(:categorys, categorys)
    |> assign(:articles, articles)
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.html", category: category)
  end

end

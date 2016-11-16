defmodule HelloPhoenix.AchieveController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{Category, Article, Tag, ArticleTag}

  def index(conn, _params) do
    articles = Article
    |> order_by(desc: :inserted_at)
    |> Repo.all
    |> Repo.preload(:category)

    conn
    |> assign(:articles, articles)
    |> render(:index)
  end
end

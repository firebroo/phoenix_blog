defmodule HelloPhoenix.CategoryController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{Category, Article, Tag}

  defp common(conn, params) do
    categorys = Category
    |> Repo.all
    |> Repo.preload(:articles)

    tags = Tag
    |> Repo.all
    |> Repo.preload(:articles)

    hot_articles = Article
    |> order_by(desc: :reading)
    |> limit(10)
    |> Repo.all
    |> Repo.preload(:category)

    conn
    |> assign(:hot_articles, hot_articles)
    |> assign(:categorys, categorys)
    |> assign(:tags, tags)
  end

  def index(conn, params) do
    conn = common(conn, params)
    pagination = Article
    |> order_by(desc: :inserted_at)
    |> preload([:category, :tags, :comments])
    |> Repo.paginate(params)

    conn
    |> assign(:pagination, pagination)
    |> render(:index)
  end

  def show(conn, params) do
    conn = common(conn, params)
    case Map.fetch(params, "id") do
      {:ok, id} ->
        pagination = Article
        |> where(category_id: ^id)
        |> order_by(desc: :inserted_at)
        |> preload([:category, :tags, :comments])
        |> Repo.paginate(params)
      {:error} ->
        pagination = Article
        |> order_by(desc: :inserted_at)
        |> preload([:category, :tags, :comments])
        |> Repo.paginate(params)
    end

    conn
    |> assign(:pagination, pagination)
    |> render(:show)
  end

end

defmodule HelloPhoenix.CategoryController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{Category, Article, Tag}

  defp common(conn, params) do
    categorys = ConCache.get_or_store(:hello_phoenix, "categorys", fn() -> 
      Category
      |> Repo.all
      |> Repo.preload(:articles)
    end)

    tags = ConCache.get_or_store(:hello_phoenix, "tags", fn() -> 
      Tag
      |> Repo.all
      |> Repo.preload(:articles)
    end)

    hot_articles = ConCache.get_or_store(:hello_phoenix, "hot_articles", fn() -> 
      Article
      |> where(block: false)
      |> order_by(desc: :reading)
      |> limit(10)
      |> Repo.all
      |> Repo.preload(:category)
    end)

    conn
    |> assign(:hot_articles, hot_articles)
    |> assign(:categorys, categorys)
    |> assign(:tags, tags)
  end

  def index(conn, params) do
    conn = common(conn, params)
    pagination = ConCache.get_or_store(:hello_phoenix, "pagination", fn() -> 
      Article
      |> where(block: false)
      |> order_by(desc: :inserted_at)
      |> preload([:category, :tags, :comments])
      |> Repo.paginate(params)
    end)

    conn
    |> assign(:pagination, pagination)
    |> render(:index)
  end

  def show(conn, params) do
    conn = common(conn, params)
    pagination = case Map.fetch(params, "id") do
      {:ok, id} ->
        category = Category |> where(hash_id: ^id) |> Repo.one!
        Article
        |> where(block: false)
        |> where(category_id: ^category.id)
        |> order_by(desc: :inserted_at)
        |> preload([:category, :tags, :comments])
        |> Repo.paginate(params)
      {:error} ->
        Article
        |> where(block: false)
        |> order_by(desc: :inserted_at)
        |> preload([:category, :tags, :comments])
        |> Repo.paginate(params)
    end

    conn
    |> assign(:pagination, pagination)
    |> render(:show)
  end

end

defmodule HelloPhoenix.SearchController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{Category, Tag, Article, Link}

  defp common(conn) do
    categorys = Category
    |> Repo.all
    |> Repo.preload(:articles)
  
    tags = Tag
    |> Repo.all
    |> Repo.preload(:articles)
  
    hot_articles = Article
    |> where(block: false)
    |> order_by(desc: :reading)
    |> limit(10)
    |> Repo.all
    |> Repo.preload(:category)

    links = ConCache.get_or_store(:hello_phoenix, "links", fn() -> 
      Link
      |> Repo.all
    end)
  
    conn
    |> assign(:hot_articles, hot_articles)
    |> assign(:categorys, categorys)
    |> assign(:tags, tags)
    |> assign(:links, links)
  end

  def index(conn, params) do
    conn = common(conn)
    pagination = case Map.fetch(params, "q") do
      {:ok, query} ->
        query = "%" <> query <> "%"
        articles = from(a in Article, where: like(a.body, ^query)) 
                   |> where(block: false)
                   |> order_by(desc: :inserted_at)
                   |> preload([:comments, :category, :tags]) 
                   |> Repo.paginate(params)
        if articles.entries == [] do
            []
        else
            articles
        end
      {:error} ->
        []
    end
    conn
    |> assign(:pagination, pagination)
    |> render(:index)
  end
end

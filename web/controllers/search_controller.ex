defmodule HelloPhoenix.SearchController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{Category, Tag, Article}

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
    pagenations = case Map.fetch(params, "q") do
      {:ok, query} ->
        query = "%" <> query <> "%"
        conn = common(conn, params)
        articles = from(a in Article, where: like(a.body, ^query)) 
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
    |> assign(:pagenations, pagenations)
    |> render(:index)
  end
end

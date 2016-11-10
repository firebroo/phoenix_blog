defmodule HelloPhoenix.TagController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Tag

  alias HelloPhoenix.{Category, Article, Tag, ArticleTag}

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

  
  def show(conn, params) do
    conn = common(conn, params)
    case Map.fetch(params, "id") do
      {:ok, id} ->
        tag = Tag |> where(name: ^id) |> Repo.one
        pagination = Article
        |> join(:inner, [a], at in ArticleTag, at.tag_id == ^tag.id and at.article_id == a.id)
        |> preload([:category, :tags, :comments])
        |> order_by(desc: :inserted_at)
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

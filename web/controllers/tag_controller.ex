defmodule HelloPhoenix.TagController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{Category, Article, Tag, ArticleTag, Link}

  defp common(conn) do
    # 缓存所有categorys
    categorys = ConCache.get_or_store(:hello_phoenix, "categorys", fn() -> 
      Category
      |> Repo.all
      |> Repo.preload(:articles)
    end)

    # 缓存所有tags
    tags = ConCache.get_or_store(:hello_phoenix, "tags", fn() -> 
      Tag
      |> Repo.all
      |> Repo.preload(:articles)
    end)

    # 缓存热门文章
    hot_articles = ConCache.get_or_store(:hello_phoenix, "hot_articles", fn() -> 
      Article
      |> where(block: false)
      |> order_by(desc: :reading)
      |> limit(10)
      |> Repo.all
      |> Repo.preload(:category)
    end)

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
  
  def show(conn, params) do
    conn = common(conn)
    pagination = case Map.fetch(params, "id") do
      {:ok, id} ->
        tag = Tag |> where(name: ^id) |> Repo.one
        Article
        |> where(block: false)
        |> join(:inner, [a], at in ArticleTag, at.tag_id == ^tag.id and at.article_id == a.id)
        |> preload([:category, :tags, :comments])
        |> order_by(desc: :inserted_at)
        |> Repo.paginate(params)
      {:error} ->
        # 缓存所有文章
        ConCache.get_or_store(:hello_phoenix, "pagination", fn() -> 
          Article
          |> where(block: false)
          |> order_by(desc: :inserted_at)
          |> preload([:category, :tags, :comments])
          |> Repo.paginate(params)
        end)
    end

    conn
    |> assign(:pagination, pagination)
    |> render(:show)
  end
end

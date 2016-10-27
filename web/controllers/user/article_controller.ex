defmodule HelloPhoenix.User.ArticleController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.{ArticleTag, Article, Category, Tag}

  def index(conn, _params) do
    articles = Article
    |> Repo.all
    |> Repo.preload(:category)

    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    categorys = Repo.all(Category)
    tags = Repo.all(Tag)

    changeset = Article.changeset(%Article{})

    conn
    |> assign(:tags, tags)
    |> assign(:exist_tags, [])
    |> assign(:categorys, categorys)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"article" => article_params, "tags" => tag_ids}) do
    changeset = Article.changeset(%Article{}, article_params)

    case Repo.insert(changeset) do
      {:ok, article} ->
        article 
        |> Repo.preload(:tags) 
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:tags, Enum.map(tag_ids, fn id -> Repo.get(Tag, id) end)) 
        |> Repo.update!

        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: user_article_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:exist_tags, [])
        |> assign(:tags, Repo.all(Tag))
        |> assign(:categorys, Repo.all(Category))
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    case Repo.insert(changeset) do
      {:ok, article} ->

        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: user_article_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:exist_tags, [])
        |> assign(:tags, Repo.all(Tag))
        |> assign(:categorys, Repo.all(Category))
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
   end


  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    render(conn, "show.html", article: article)
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get!(Article, id) |> Repo.preload(:tags)
    exist_tags = article.tags
    tags = Repo.all(Tag)
    categorys = Repo.all(Category)
    changeset = Article.changeset(article)

    conn
    |> assign(:tags, tags)
    |> assign(:exist_tags, exist_tags)
    |> assign(:article, article)
    |> assign(:changeset, changeset)
    |> assign(:categorys, categorys)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "article" => article_params, "tags" => tag_ids}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        from(p in ArticleTag, where: p.article_id == ^id) |> Repo.delete_all  # 删除之前所有关联

        article                                                           # 重新插入所有关联
        |> Repo.preload(:tags) 
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:tags, Enum.map(tag_ids, fn id -> Repo.get(Tag, id) end)) 
        |> Repo.update!

        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: user_article_path(conn, :show, article))
      {:error, changeset} ->
        conn
        |> assign(:exist_tags, [])
        |> assign(:article, article)
        |> assign(:tags, Repo.all(Tag))
        |> assign(:changeset, changeset)
        |> assign(:categorys, Repo.all(Category))
        |> render("edit.html")
    end
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        from(p in ArticleTag, where: p.article_id == ^id) |> Repo.delete_all  # 删除之前所有关联

        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: user_article_path(conn, :show, article))
      {:error, changeset} ->
        conn
        |> assign(:exist_tags, [])
        |> assign(:article, article)
        |> assign(:tags, Repo.all(Tag))
        |> assign(:changeset, changeset)
        |> assign(:categorys, Repo.all(Category))
        |> render("edit.html")
    end
   end


  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: user_article_path(conn, :index))
  end
end

defmodule HelloPhoenix.ArticleController do
    use HelloPhoenix.Web, :controller

    # 导入Model
    alias HelloPhoenix.{Category, Article, Comment}

    def index(conn, %{"category_id" => category_id}) do
        categorys = Repo.all(Category)

        category = Category
        |> Repo.get!(category_id)
        |> Repo.preload([:articles])

        conn
        |> assign(:category, category)
        |> assign(:categorys, categorys)
        |> assign(:category_id, category_id)
        |> render("index.html")
    end

    def show(conn, %{"category_id" => category_id, "id" => id}) do
        article = Article
        |> Repo.get!(id)
        |> Repo.preload([:comments])

        # 更新文章阅读次数
        Article.changeset(article, %{reading: article.reading + 1}) |> Repo.update!


        changeset = Comment.changeset(%Comment{})

        conn
        |> assign(:article, article)
        |> assign(:changeset, changeset)
        |> assign(:category_id, category_id)
        |> render("show.html")
    end

    def new(conn, %{"category_id" => category_id}) do
        changeset = Article.changeset(%Article{})

        conn
        |> assign(:changeset, changeset)
        |> assign(:category_id, category_id)
        |> render("new.html")
    end

    def create(conn, %{"category_id" => category_id, "article" => article_params}) do
        article_params = article_params
        |> Map.put_new("category_id", category_id)

        changeset = Article.changeset(%Article{}, article_params)
        case Repo.insert(changeset) do
        {:ok, _article} ->
           conn
           |> put_flash(:info, "文章创建成功.")
           |> redirect(to: category_article_path(conn, :index, category_id))
        {:error, changeset} ->
           conn
           |> assign(:changeset, changeset) 
           |> assign(:category_id, category_id) 
           |> render("new.html")
        end

    end

    def edit(conn, %{"category_id" => category_id, "id" => id}) do
        article = Article
        |> Repo.get!(id)
        
        changeset = Article.changeset(article)

        conn
        |> assign(:article, article)
        |> assign(:changeset, changeset)
        |> assign(:category_id, category_id)
        |> render("edit.html")
    end

    def update(conn, %{"category_id" => category_id, "id" => id, "article" => article_params}) do
        article = Repo.get(Article, id)
        changeset = Article.changeset(article, article_params)

        case Repo.update(changeset) do
            {:ok, _} ->
               conn
               |> put_flash(:info, "文章更新成功")
               |> redirect(to: category_article_path(conn, :index, category_id))
            {:error, _changeset} ->
               conn
               |> put_flash(:error, "文章更新失败")
               |> redirect(to: category_article_path(conn, :edit, category_id))
        end
    end

    def delete(conn, %{"category_id" => category_id, "id" => id}) do
        Article
        |> Repo.get!(id)
        |> Repo.delete!

        conn
        |> put_flash(:info, "文章删除成功.")
        |> redirect(to: category_article_path(conn, :index, category_id))
    end
end

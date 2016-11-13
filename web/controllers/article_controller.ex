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
        |> where(hash_id: ^id)
        |> Repo.one!
        |> Repo.preload([:category, :tags, :comments])
        
        if category_id != article.category.hash_id do
            conn 
            |> put_layout(false)
            |> render HelloPhoenix.ErrorView, "404.html" 
        else
            comments = Comment
            |> where(article_id: ^article.id)
            |> order_by(asc: :inserted_at)
            |> Repo.all

            # 更新文章阅读次数
            Article.changeset(article, %{reading: article.reading + 1}) |> Repo.update!


            changeset = Comment.changeset(%Comment{})

            conn
            |> assign(:article, article)
            |> assign(:comments, comments)
            |> assign(:changeset, changeset)
            |> assign(:category_id, category_id)
            |> render("show.html")
        end
    end
end

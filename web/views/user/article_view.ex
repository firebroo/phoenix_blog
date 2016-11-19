defmodule HelloPhoenix.User.ArticleView do
  use HelloPhoenix.Web, :view

  def category_name(article) do
    article.category.name
  end

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end
end

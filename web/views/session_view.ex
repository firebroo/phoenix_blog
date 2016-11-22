defmodule HelloPhoenix.SessionView do
  use HelloPhoenix.Web, :view

  def category_name(article) do
    article.category.name
  end
end

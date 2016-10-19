defmodule HelloPhoenix.User.CommentView do
  use HelloPhoenix.Web, :view

  def article_name(comment) do
    comment.article.title
  end
end

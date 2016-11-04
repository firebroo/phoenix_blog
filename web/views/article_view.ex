defmodule HelloPhoenix.ArticleView do
  use HelloPhoenix.Web, :view

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end
end

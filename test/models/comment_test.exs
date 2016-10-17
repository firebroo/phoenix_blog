defmodule HelloPhoenix.CommentTest do
  use HelloPhoenix.ModelCase

  alias HelloPhoenix.Comment

  @valid_attrs %{body: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end

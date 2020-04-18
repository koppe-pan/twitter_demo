defmodule TwitterDemoWeb.CommentView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{comments: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      slug: comment.tweet_id,
      body: comment.body,
      createdAt: comment.inserted_at,
      author: TwitterDemo.Users.get_user!(comment.user_id).name
    }
  end
end

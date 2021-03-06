defmodule TwitterDemoWeb.CommentController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Comments
  alias TwitterDemo.Comments.Comment

  action_fallback TwitterDemoWeb.FallbackController

  plug TwitterDemoWeb.Plugs.Auth, [optional: true] when action in [:index, :show]
  plug TwitterDemoWeb.Plugs.Auth when action in [:create, :delete]

  def index(conn, %{"tweet_id" => id}) do
    comments = Comments.list_comments(%{tweet_id: id})
    render(conn, "index.json", comments: comments)
  end

  def create(%{assigns: %{current_user: current_user}} = conn, %{
        "comment" => comment_params,
        "tweet_id" => tweet_id
      }) do
    comment_params =
      Map.put(comment_params, "tweet_id", tweet_id)
      |> Map.put("user_id", current_user.id)

    with {:ok, %Comment{} = comment} <- Comments.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.comment_path(conn, :show, tweet_id, comment)
      )
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"tweet_id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{}} <- Comments.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end

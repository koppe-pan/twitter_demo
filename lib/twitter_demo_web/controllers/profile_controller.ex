defmodule TwitterDemoWeb.ProfileController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Users
  alias TwitterDemo.Relationship

  action_fallback TwitterDemoWeb.FallbackController

  def get(conn, %{"authorname" => authorname}) do
    user = Users.get_by_name!(authorname)

    render(conn, "get.json", user: user)
  end

  def get(conn, %{"authorname" => authorname, "id" => user_id}) do
    user = Users.get_by_name!(authorname)

    render(conn, "get.json", user: user, user_id: user_id)
  end

  def follow(conn, %{"authorname" => authorname, "id" => id}) do
    user = Users.get_by_name!(authorname)

    with {:ok, %Relationship{} = rel} <- Relationship.follow(id, user.id) do
      conn
      |> put_status(:created)
      |> render("follow.json", relationship: rel)
    end
  end

  def unfollow(conn, %{"authorname" => authorname, "id" => id}) do
    user = Users.get_by_name!(authorname)

    with {:ok, %Relationship{}} <- Relationship.unfollow(id, user.id) do
      send_resp(conn, :no_content, "")
    end
  end
end

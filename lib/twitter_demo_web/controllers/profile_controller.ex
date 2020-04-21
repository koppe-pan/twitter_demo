defmodule TwitterDemoWeb.ProfileController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Users
  alias TwitterDemo.Relationship

  action_fallback TwitterDemoWeb.FallbackController

  def get(conn, %{"authorname" => authorname, "username" => username}) do
    author = Users.get_by_name!(authorname)
    user = Users.get_by_name!(username)

    profile = %{
      name: author.name,
      following: TwitterDemo.Relationship.following?(user.id, author.id),
      introduction: author.introduction
    }

    render(conn, "get.json", profile: profile)
  end

  def get(conn, %{"authorname" => authorname}) do
    author = Users.get_by_name!(authorname)

    profile = %{
      name: author.name,
      following: false,
      introduction: author.introduction
    }

    render(conn, "get.json", profile: profile)
  end

  def follow(conn, %{"authorname" => authorname, "followername" => followername}) do
    follower = Users.get_by_name!(followername)
    user = Users.get_by_name!(authorname)

    with {:ok, %Relationship{} = rel} <- Relationship.follow(follower.id, user.id) do
      conn
      |> put_status(:created)
      |> render("follow.json", relationship: rel)
    end
  end

  def unfollow(conn, %{"authorname" => authorname, "followername" => followername}) do
    follower = Users.get_by_name!(followername)
    user = Users.get_by_name!(authorname)

    with {:ok, %Relationship{}} <- Relationship.unfollow(follower.id, user.id) do
      send_resp(conn, :no_content, "")
    end
  end
end

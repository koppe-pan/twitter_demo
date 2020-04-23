defmodule TwitterDemoWeb.ProfileController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Users
  alias TwitterDemo.Relationship

  action_fallback TwitterDemoWeb.FallbackController

  plug TwitterDemoWeb.Plugs.Auth, [optional: true] when action in [:index, :show]
  plug TwitterDemoWeb.Plugs.Auth when action in [:follow, :unfollow]

  def show(%{assigns: %{current_user: current_user}} = conn, %{"authorname" => authorname}) do
    author = Users.get_by_name!(authorname)

    profile = %{
      name: author.name,
      following: TwitterDemo.Relationship.following?(current_user.id, author.id),
      introduction: author.introduction
    }

    render(conn, "get.json", profile: profile)
  end

  def show(conn, %{"authorname" => authorname}) do
    author = Users.get_by_name!(authorname)

    profile = %{
      name: author.name,
      following: false,
      introduction: author.introduction
    }

    render(conn, "get.json", profile: profile)
  end

  def follow(%{assigns: %{current_user: current_user}} = conn, %{"authorname" => authorname}) do
    user = Users.get_by_name!(authorname)

    with {:ok, %Relationship{} = rel} <- Relationship.follow(current_user.id, user.id) do
      conn
      |> put_status(:created)
      |> render("follow.json", relationship: rel)
    end
  end

  def unfollow(%{assigns: %{current_user: current_user}} = conn, %{"authorname" => authorname}) do
    user = Users.get_by_name!(authorname)

    with {:ok, %Relationship{}} <- Relationship.unfollow(current_user.id, user.id) do
      send_resp(conn, :no_content, "")
    end
  end
end

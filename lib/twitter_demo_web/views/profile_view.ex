defmodule TwitterDemoWeb.ProfileView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.ProfileView
  alias TwitterDemo.Users

  def render("follow.json", %{relationship: rel}) do
    follower = Users.get_user!(rel.follower_id)
    ProfileView.render("prof.json", follower: follower)
  end

  def render("get.json", %{user: user}) do
    %{
      profile: %{
        name: user.name,
        following: false
      }
    }
  end

  def render("get.json", %{user: user, user_id: user_id}) do
    following = TwitterDemo.Relationship.following?(user_id, user.id)

    %{
      profile: %{
        name: user.name,
        following: following
      }
    }
  end

  def render("prof.json", %{follower: follower}) do
    %{
      username: follower.name,
      slug: follower.id
    }
  end
end

defmodule TwitterDemoWeb.ProfileView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.ProfileView
  alias TwitterDemo.Users

  def render("follow.json", %{relationship: rel}) do
    follower = Users.get_user!(rel.follower_id)
    ProfileView.render("prof.json", follower: follower)
  end

  def render("get.json", %{profile: profile}) do
    %{
      profile: %{
        name: profile.name,
        following: profile.following,
        introduction: profile.introduction
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

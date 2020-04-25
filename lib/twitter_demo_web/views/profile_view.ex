defmodule TwitterDemoWeb.ProfileView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.ProfileView
  alias TwitterDemo.Users

  def render("follow.json", %{relationship: rel}) do
    followed = Users.get_user!(rel.followed_id)
    ProfileView.render("prof.json", followed: followed)
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

  def render("prof.json", %{followed: followed}) do
    %{
      username: followed.name,
      slug: followed.id
    }
  end
end

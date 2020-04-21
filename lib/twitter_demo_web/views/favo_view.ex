defmodule TwitterDemoWeb.FavoView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.FavoView
  alias TwitterDemo.Tweets
  alias TwitterDemo.Favo

  def render("favo.json", %{favo: fav}) do
    favorited = Favo.favoring?(fav.tweet_id, fav.user_id)
    favorites = Tweets.get_tweet!(fav.tweet_id).favorites

    %{
      favorited: favorited,
      favorites: favorites
    }
  end

  def render("get.json", %{profile: profile}) do
    %{
      profile: %{
        name: profile.name,
        following: profile.following
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

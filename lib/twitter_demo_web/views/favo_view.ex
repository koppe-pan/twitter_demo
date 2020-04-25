defmodule TwitterDemoWeb.FavoView do
  use TwitterDemoWeb, :view
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
end

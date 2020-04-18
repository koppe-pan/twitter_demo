defmodule TwitterDemoWeb.TweetView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.TweetView
  alias TwitterDemo.Users

  def render("index.json", %{tweets: tweets}) do
    %{tweets: render_many(tweets, TweetView, "list.json")}
  end

  def render("show.json", %{tweet: tweet}) do
    %{data: render_one(tweet, TweetView, "tweet.json")}
  end

  def render("list.json", %{tweet: tweet}) do
    %{
      slug: tweet.id,
      description: tweet.description,
      favorited: tweet.favorited,
      favorites: tweet.favorites,
      author: Users.get_user!(tweet.user_id).name
    }
  end

  def render("tweet.json", %{tweet: tweet}) do
    %{
      tweet: %{
        slug: tweet.id,
        description: tweet.description,
        favorited: tweet.favorited,
        favorites: tweet.favorites
      },
      author: Users.get_user!(tweet.user_id).name
    }
  end
end

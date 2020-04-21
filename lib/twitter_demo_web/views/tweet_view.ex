defmodule TwitterDemoWeb.TweetView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.TweetView
  alias TwitterDemo.Users

  def render("index.json", %{tweets: tweets}) do
    %{tweets: render_many(tweets, TweetView, "tweet.json")}
  end

  def render("index_with_favorited.json", %{tweets: tweets}) do
    %{tweets: render_many(tweets, TweetView, "tweet_with_favorited.json")}
  end

  def render("show.json", %{tweet: tweet}) do
    %{data: render_one(tweet, TweetView, "tweet.json")}
  end

  def render("show_with_favorited.json", %{tweet: tweet}) do
    %{data: render_one(tweet, TweetView, "tweet_with_favorited.json")}
  end

  def render("tweet_with_favorited.json", %{tweet: tweet}) do
    %{
      slug: tweet.id,
      description: tweet.description,
      favorited: tweet.favorited,
      favorites: tweet.favorites,
      createdAt: tweet.inserted_at,
      author: Users.get_user!(tweet.user_id).name
    }
  end

  def render("tweet.json", %{tweet: tweet}) do
    %{
      slug: tweet.id,
      description: tweet.description,
      favorites: tweet.favorites,
      createdAt: tweet.inserted_at,
      author: Users.get_user!(tweet.user_id).name
    }
  end
end

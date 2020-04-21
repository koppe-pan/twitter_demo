defmodule TwitterDemoWeb.TweetController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Tweets
  alias TwitterDemo.Tweets.Tweet

  action_fallback TwitterDemoWeb.FallbackController

  def index(conn, %{"author" => author, "user" => username}) do
    tweets =
      Tweets.list_tweets(%{name: author})
      |> Enum.map(fn tweet -> Tweets.put_favorited!(tweet, username) end)

    render(conn, "index_with_favorited.json", tweets: tweets)
  end

  def index(conn, %{"username" => username}) do
    tweets =
      Tweets.list_tweets()
      |> Enum.map(fn tweet -> Tweets.put_favorited!(tweet, username) end)

    render(conn, "index_with_favorited.json", tweets: tweets)
  end

  def feed(conn, %{"name" => name}) do
    with {:ok, users} <-
           TwitterDemo.Users.get_by_name!(name)
           |> TwitterDemo.Repo.preload(:reverse_relationships)
           |> Map.fetch(:reverse_relationships) do
      tweets =
        users
        |> Enum.map(fn user -> Tweets.list_tweets(%{name: user.name}) end)
        |> Enum.concat()
        |> Enum.map(fn tweet -> Tweets.put_favorited!(tweet, name) end)

      render(conn, "index_with_favorited.json", tweets: tweets)
    end
  end

  def index(conn, _params) do
    tweets = Tweets.list_tweets()
    render(conn, "index.json", tweets: tweets)
  end

  def create(conn, %{"tweet" => tweet_params}) do
    with {:ok, %Tweet{} = tweet} <- Tweets.create_tweet(tweet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tweet_path(conn, :show, tweet))
      |> render("show.json", tweet: tweet)
    end
  end

  def show(conn, %{"id" => id, "name" => name}) do
    tweet =
      Tweets.get_tweet!(id)
      |> Tweets.put_favorited!(name)

    render(conn, "show_with_favorited.json", tweet: tweet)
  end

  def show(conn, %{"id" => id}) do
    tweet = Tweets.get_tweet!(id)
    render(conn, "show.json", tweet: tweet)
  end

  def update(conn, %{"id" => id, "tweet" => tweet_params}) do
    tweet = Tweets.get_tweet!(id)

    with {:ok, %Tweet{} = tweet} <- Tweets.update_tweet(tweet, tweet_params) do
      render(conn, "show.json", tweet: tweet)
    end
  end

  def favo(conn, %{"id" => id, "name" => name}) do
    with tweet <-
           id
           |> Tweets.get_tweet!()
           |> Tweets.inc_favorites()
           |> Tweets.put_favorited!(name) do
      render(conn, "show_with_favorited.json", tweet: tweet)
    end
  end

  def unfavo(conn, %{"id" => id, "name" => name}) do
    with tweet <-
           id
           |> Tweets.get_tweet!()
           |> Tweets.dec_favorites()
           |> Tweets.put_favorited!(name) do
      render(conn, "show_with_favorited.json", tweet: tweet)
    end
  end

  def delete(conn, %{"id" => id}) do
    tweet = Tweets.get_tweet!(id)

    with {:ok, %Tweet{}} <- Tweets.delete_tweet(tweet) do
      send_resp(conn, :no_content, "")
    end
  end
end

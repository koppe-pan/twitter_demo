defmodule TwitterDemoWeb.TweetController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Tweets
  alias TwitterDemo.Tweets.Tweet

  action_fallback TwitterDemoWeb.FallbackController

  plug TwitterDemoWeb.Plugs.Auth, [optional: true] when action in [:index, :show]
  plug TwitterDemoWeb.Plugs.Auth when action in [:create, :delete, :feed]

  def index(
        %{assigns: %{current_user: current_user}} = conn,
        %{"author" => author_name} = _params
      ) do
    tweets =
      Tweets.list_tweets(%{name: author_name})
      |> Enum.map(fn tweet -> Tweets.put_favorited!(tweet, current_user.id) end)

    render(conn, "index_with_favorited.json", tweets: tweets)
  end

  def index(%{assigns: %{current_user: current_user}} = conn, _params) do
    tweets =
      Tweets.list_tweets()
      |> Enum.map(fn tweet -> Tweets.put_favorited!(tweet, current_user.id) end)

    render(conn, "index_with_favorited.json", tweets: tweets)
  end

  def index(conn, _params) do
    tweets = Tweets.list_tweets()
    render(conn, "index.json", tweets: tweets)
  end

  def feed(%{assigns: %{current_user: current_user}} = conn, _params) do
    with {:ok, users} <-
           current_user
           |> TwitterDemo.Repo.preload(:relationships)
           |> Map.fetch(:relationships) do
      tweets =
        users
        |> Enum.map(fn user -> Tweets.list_tweets(%{name: user.name}) end)
        |> Enum.concat()
        |> Enum.map(fn tweet -> Tweets.put_favorited!(tweet, current_user.id) end)

      render(conn, "index_with_favorited.json", tweets: tweets)
    end
  end

  def create(%{assigns: %{current_user: current_user}} = conn, %{"tweet" => tweet_params}) do
    with {:ok, %Tweet{} = tweet} <- Tweets.create_tweet(current_user, tweet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tweet_path(conn, :show, tweet))
      |> render("show.json", tweet: tweet)
    end
  end

  def show(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    tweet =
      Tweets.get_tweet!(id)
      |> Tweets.put_favorited!(current_user.id)

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

  def favo(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    with tweet <-
           id
           |> Tweets.get_tweet!()
           |> Tweets.inc_favorites()
           |> Tweets.put_favorited!(current_user.id) do
      render(conn, "show_with_favorited.json", tweet: tweet)
    end
  end

  def unfavo(%{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    with tweet <-
           id
           |> Tweets.get_tweet!()
           |> Tweets.dec_favorites()
           |> Tweets.put_favorited!(current_user.id) do
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

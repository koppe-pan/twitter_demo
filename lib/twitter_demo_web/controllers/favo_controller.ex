defmodule TwitterDemoWeb.FavoController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Users
  alias TwitterDemo.Tweets
  alias TwitterDemo.Favo

  action_fallback TwitterDemoWeb.FallbackController

  def get(conn, %{"authorname" => authorname, "username" => username}) do
    author = Users.get_by_name!(authorname)
    user = Users.get_by_name!(username)

    profile = %{
      name: author.name,
      following: TwitterDemo.Favo.favoring?(user.id, author.id)
    }

    render(conn, "get.json", profile: profile)
  end

  def get(conn, %{"authorname" => authorname}) do
    author = Users.get_by_name!(authorname)

    profile = %{
      name: author.name,
      following: false
    }

    render(conn, "get.json", profile: profile)
  end

  def favo(conn, %{"id" => tweet_id, "name" => favorername}) do
    favorer = Users.get_by_name!(favorername)

    with {:ok, %Favo{} = fav} <- Favo.favo(tweet_id, favorer.id) do
      Tweets.get_tweet!(tweet_id)
      |> Tweets.inc_favorites()

      conn
      |> put_status(:created)
      |> render("favo.json", favo: fav)
    end
  end

  def unfavo(conn, %{"id" => tweet_id, "name" => favorername}) do
    favorer = Users.get_by_name!(favorername)

    with {:ok, %Favo{} = fav} <- Favo.unfavo(tweet_id, favorer.id) do
      Tweets.get_tweet!(tweet_id)
      |> Tweets.dec_favorites()

      conn
      |> render("favo.json", favo: fav)
    end
  end
end

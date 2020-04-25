defmodule TwitterDemoWeb.FavoController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Tweets
  alias TwitterDemo.Favo

  action_fallback TwitterDemoWeb.FallbackController

  plug TwitterDemoWeb.Plugs.Auth when action in [:favo, :unfavo]

  def favo(%{assigns: %{current_user: current_user}} = conn, %{"id" => tweet_id}) do
    with {:ok, %Favo{} = fav} <- Favo.favo(tweet_id, current_user.id) do
      Tweets.get_tweet!(tweet_id)
      |> Tweets.inc_favorites()

      conn
      |> put_status(:created)
      |> render("favo.json", favo: fav)
    end
  end

  def unfavo(%{assigns: %{current_user: current_user}} = conn, %{"id" => tweet_id}) do
    with {:ok, %Favo{} = fav} <- Favo.unfavo(tweet_id, current_user.id) do
      Tweets.get_tweet!(tweet_id)
      |> Tweets.dec_favorites()

      conn
      |> render("favo.json", favo: fav)
    end
  end
end

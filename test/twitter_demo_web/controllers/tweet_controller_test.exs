defmodule TwitterDemoWeb.TweetControllerTest do
  use TwitterDemoWeb.ConnCase

  alias TwitterDemo.Tweets
  alias TwitterDemo.Tweets.Tweet

  @user_attrs %{
    name: "some name",
    email: "some @email",
    password: "S0me p@ssw0rd"
  }
  @create_attrs %{
    :description => "some description",
    "author" => "some name",
    :favorited => true,
    :favorites => 42
  }
  @update_attrs %{
    :description => "some updated description",
    "author" => "some name",
    :favorited => false,
    :favorites => 43
  }
  @invalid_attrs %{
    :description => nil,
    "author" => "some name",
    :favorited => nil,
    :favorites => nil
  }

  def fixture(:tweet) do
    {:ok, tweet} = Tweets.create_tweet(@create_attrs)
    tweet
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post(Routes.user_path(conn, :create), user: @user_attrs)

    {:ok, token} =
      json_response(conn, 201)["data"]
      |> Map.fetch("token")

    conn =
      conn
      |> recycle()
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all tweets", %{conn: conn} do
      conn = get(conn, Routes.tweet_path(conn, :index), name: "some name")
      assert json_response(conn, 200)["tweets"] == []
    end
  end

  describe "create tweet" do
    test "renders tweet when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: @create_attrs)
      assert %{"slug" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tweet_path(conn, :show, id))

      assert %{
               "slug" => id,
               "description" => "some description",
               "favorites" => 0
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tweet" do
    setup [:create_tweet]

    test "renders tweet when data is valid", %{conn: conn, tweet: %Tweet{id: id} = tweet} do
      conn = put(conn, Routes.tweet_path(conn, :update, tweet), tweet: @update_attrs)

      assert %{"slug" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tweet_path(conn, :show, id))

      assert %{
               "slug" => id,
               "description" => "some updated description",
               "favorites" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tweet: tweet} do
      conn = put(conn, Routes.tweet_path(conn, :update, tweet), tweet: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tweet" do
    setup [:create_tweet]

    test "deletes chosen tweet", %{conn: conn, tweet: tweet} do
      conn = delete(conn, Routes.tweet_path(conn, :delete, tweet))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tweet_path(conn, :show, tweet))
      end
    end
  end

  defp create_tweet(_) do
    tweet = fixture(:tweet)
    {:ok, tweet: tweet}
  end
end

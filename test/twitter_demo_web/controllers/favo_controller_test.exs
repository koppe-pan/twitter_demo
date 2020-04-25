defmodule TwitterDemoWeb.FavoControllerTest do
  use TwitterDemoWeb.ConnCase

  alias TwitterDemo.Favo

  @user_attrs %{
    email: "some @email",
    name: "some name",
    password: "S0me p@ssw0rd"
  }
  @tweet_attrs %{
    description: "some description"
  }

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post(Routes.user_path(conn, :create), user: @user_attrs)

    %{"token" => token, "user" => %{"id" => user_id}} = json_response(conn, 201)["data"]

    conn =
      conn
      |> recycle()
      |> put_req_header("authorization", "Bearer " <> token)
      |> post(Routes.tweet_path(conn, :create), tweet: @tweet_attrs)

    %{"slug" => tweet_id} = json_response(conn, 201)["data"]
    {:ok, conn: recycle(conn), tweet_id: tweet_id, user_id: user_id}
  end

  describe "favo" do
    test "favo tweet", %{conn: conn, tweet_id: tweet_id} do
      conn = post(conn, Routes.favo_path(conn, :favo, tweet_id))

      assert %{
               "favorited" => true,
               "favorites" => 1
             } = json_response(conn, 201)
    end
  end

  describe "unfavo" do
    test "unfavo tweet", %{conn: conn, tweet_id: tweet_id, user_id: user_id} do
      assert {:ok, %Favo{}} = Favo.favo(tweet_id, user_id)
      assert Favo.favoring?(tweet_id, user_id) == true
      conn = delete(conn, Routes.favo_path(conn, :unfavo, tweet_id))

      assert %{
               "favorited" => false,
               "favorites" => -1
             } = json_response(conn, 200)
    end
  end
end

defmodule TwitterDemoWeb.CommentControllerTest do
  use TwitterDemoWeb.ConnCase

  alias TwitterDemo.Comments

  @user_attrs %{
    name: "some name",
    email: "some @email",
    password: "S0me p@ssw0rd"
  }

  @tweet_attrs %{
    description: "some description"
  }

  @create_attrs %{
    body: "some body"
  }
  #  @update_attrs %{
  #    body: "some updated body"
  #  }
  @invalid_attrs %{body: nil}

  def fixture(:comment) do
    {:ok, comment} = Comments.create_comment(@create_attrs)
    comment
  end

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

  describe "index" do
    test "lists all comments", %{conn: conn, tweet_id: tweet_id} do
      conn = get(conn, Routes.comment_path(conn, :index, tweet_id))
      assert json_response(conn, 200)["comments"] == []
    end
  end

  describe "create comment" do
    test "renders comment when data is valid", %{conn: conn, tweet_id: tweet_id} do
      conn = post(conn, Routes.comment_path(conn, :create, tweet_id), comment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.comment_path(conn, :show, tweet_id, id))

      assert %{
               "id" => id,
               "body" => "some body"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tweet_id: tweet_id} do
      conn = post(conn, Routes.comment_path(conn, :create, tweet_id), comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  #  describe "update comment" do
  #    setup [:create_comment]
  #
  #    test "renders comment when data is valid", %{
  #      conn: conn,
  #      tweet_id: tweet_id,
  #      comment: %Comment{id: id} = comment
  #    } do
  #      conn =
  #        put(conn, Routes.comment_path(conn, :update, comment, tweet_id), comment: @update_attrs)
  #
  #      assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #
  #      conn = get(conn, Routes.comment_path(conn, :show, tweet_id, id))
  #
  #      assert %{
  #               "id" => id,
  #               "body" => "some updated body"
  #             } = json_response(conn, 200)["data"]
  #    end
  #
  #    test "renders errors when data is invalid", %{
  #      conn: conn,
  #      tweet_id: tweet_id,
  #      comment: comment
  #    } do
  #      conn =
  #        put(conn, Routes.comment_path(conn, :update, tweet_id, comment), comment: @invalid_attrs)
  #
  #      assert json_response(conn, 422)["errors"] != %{}
  #    end
  #  end

  describe "delete comment" do
    test "deletes chosen comment", %{
      conn: conn,
      user_id: user_id,
      tweet_id: tweet_id
    } do
      {:ok, comment} = create_comment(user_id, tweet_id)
      conn = delete(conn, Routes.comment_path(conn, :delete, tweet_id, comment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.comment_path(conn, :show, tweet_id, comment))
      end
    end
  end

  defp create_comment(user_id, tweet_id) do
    create_attrs = %{"body" => "some body", "user_id" => user_id, "tweet_id" => tweet_id}

    Comments.create_comment(create_attrs)
  end
end

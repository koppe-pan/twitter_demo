defmodule TwitterDemo.CommentsTest do
  use TwitterDemo.DataCase

  alias TwitterDemo.Comments
  alias TwitterDemo.Tweets

  describe "comments" do
    alias TwitterDemo.Comments.Comment

    @user_attrs %{
      email: "some @email",
      name: "some name",
      password: "S0me p@ssw0rd"
    }
    @tweet_attrs %{description: "some description", favorited: true, favorites: 42}
    @valid_attrs %{"body" => "some body"}
    @update_attrs %{"body" => "some updated body"}
    @invalid_attrs %{"body" => nil}

    def user_fixture() do
      {:ok, user} =
        %{}
        |> Enum.into(@user_attrs)
        |> TwitterDemo.Users.create_user()

      user
    end

    def tweet_fixture(attrs \\ %{}) do
      user = user_fixture()

      attrs =
        attrs
        |> Enum.into(@tweet_attrs)

      {:ok, tweet} = Tweets.create_tweet(user, attrs)

      {tweet, user}
    end

    def comment_fixture(attrs \\ %{}) do
      {tweet, user} = tweet_fixture()

      attrs =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put("user_id", user.id)
        |> Map.put("tweet_id", tweet.id)

      {:ok, comment} = Comments.create_comment(attrs)

      {comment, tweet, user}
    end

    test "list_comments/0 returns all comments" do
      {comment, _tweet, _user} = comment_fixture()
      assert Comments.list_comments() == [comment]
    end

    test "list_comments/1 returns all comments belong to tweet" do
      {comment, tweet, _user} = comment_fixture()
      assert Comments.list_comments(%{tweet_id: tweet.id}) == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      {comment, _tweet, _user} = comment_fixture()
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/3 with valid data creates a comment" do
      {tweet, user} = tweet_fixture()

      attrs =
        %{}
        |> Enum.into(@valid_attrs)
        |> Map.put("user_id", user.id)
        |> Map.put("tweet_id", tweet.id)

      assert {:ok, %Comment{} = comment} = Comments.create_comment(attrs)
      assert comment.body == "some body"
    end

    test "create_comment/3 with invalid data returns error changeset" do
      {tweet, user} = tweet_fixture()

      attrs =
        %{}
        |> Enum.into(@invalid_attrs)
        |> Map.put("user_id", user.id)
        |> Map.put("tweet_id", tweet.id)

      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      {comment, _tweet, _user} = comment_fixture()
      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, @update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      {comment, _tweet, _user} = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      {comment, _tweet, _user} = comment_fixture()
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      {comment, _tweet, _user} = comment_fixture()
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end

defmodule TwitterDemo.TweetsTest do
  use TwitterDemo.DataCase

  alias TwitterDemo.Tweets

  describe "tweets" do
    alias TwitterDemo.Tweets.Tweet

    @user_attrs %{
      email: "some @email",
      name: "some name",
      password: "S0me p@ssw0rd"
    }
    @valid_attrs %{description: "some description", favorited: true, favorites: 42}
    @update_attrs %{description: "some updated description", favorited: false, favorites: 43}
    @invalid_attrs %{description: nil, favorited: nil, favorites: nil}

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
        |> Enum.into(@valid_attrs)

      {:ok, tweet} = Tweets.create_tweet(user, attrs)

      {tweet, user}
    end

    test "list_tweets/0 returns all tweets" do
      {tweet, _user} = tweet_fixture()
      assert Tweets.list_tweets() == [tweet]
    end

    test "list_tweet/1 returns the tweet with given name" do
      {tweet, user} = tweet_fixture()
      assert Tweets.list_tweets(%{name: user.name}) == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      {tweet, _user} = tweet_fixture()
      assert Tweets.get_tweet!(tweet.id) == tweet
    end

    test "put_favorited!/2 put attr favorited" do
      {tweet, user} = tweet_fixture()
      tweet = Tweets.put_favorited!(tweet, user.id)
      assert tweet.favorited == false
    end

    test "create_tweet/2 with valid data creates a tweet" do
      user = user_fixture()
      assert {:ok, %Tweet{} = tweet} = Tweets.create_tweet(user, @valid_attrs)
      assert tweet.description == "some description"
      assert tweet.favorites == 0
    end

    test "create_tweet/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Tweets.create_tweet(user, @invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      {pre_tweet, _user} = tweet_fixture()
      assert {:ok, %Tweet{} = tweet} = Tweets.update_tweet(pre_tweet, @update_attrs)
      assert tweet.description == "some updated description"
      assert tweet.favorites == pre_tweet.favorites
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      {tweet, _user} = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Tweets.update_tweet(tweet, @invalid_attrs)
      assert tweet == Tweets.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      {tweet, _user} = tweet_fixture()
      assert {:ok, %Tweet{}} = Tweets.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Tweets.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      {tweet, _user} = tweet_fixture()
      assert %Ecto.Changeset{} = Tweets.change_tweet(tweet)
    end

    test "inc_favorites/1 makes favorites increase" do
      {pre_tweet, _user} = tweet_fixture()
      tweet = Tweets.inc_favorites(pre_tweet)
      assert tweet.favorites == pre_tweet.favorites + 1
    end

    test "dec_favorites/1 makes favorites increase" do
      {pre_tweet, _user} = tweet_fixture()
      tweet = Tweets.dec_favorites(pre_tweet)
      assert tweet.favorites == pre_tweet.favorites - 1
    end
  end
end

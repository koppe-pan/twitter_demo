defmodule TwitterDemo.TweetsTest do
  use TwitterDemo.DataCase

  alias TwitterDemo.Tweets

  describe "tweets" do
    alias TwitterDemo.Tweets.Tweet

    @valid_attrs %{description: "some description", favorited: true, favorites: 42}
    @update_attrs %{description: "some updated description", favorited: false, favorites: 43}
    @invalid_attrs %{description: nil, favorited: nil, favorites: nil}

    def tweet_fixture(attrs \\ %{}) do
      {:ok, tweet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tweets.create_tweet()

      tweet
    end

    test "list_tweets/0 returns all tweets" do
      tweet = tweet_fixture()
      assert Tweets.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      assert Tweets.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      assert {:ok, %Tweet{} = tweet} = Tweets.create_tweet(@valid_attrs)
      assert tweet.description == "some description"
      assert tweet.favorited == true
      assert tweet.favorites == 42
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tweets.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{} = tweet} = Tweets.update_tweet(tweet, @update_attrs)
      assert tweet.description == "some updated description"
      assert tweet.favorited == false
      assert tweet.favorites == 43
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Tweets.update_tweet(tweet, @invalid_attrs)
      assert tweet == Tweets.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Tweets.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Tweets.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Tweets.change_tweet(tweet)
    end
  end
end

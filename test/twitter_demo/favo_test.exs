defmodule TwitterDemo.FavoTest do
  use TwitterDemo.DataCase

  alias TwitterDemo.Favo

  describe "favo" do
    @user_attrs %{
      email: "some @email",
      name: "some name",
      password: "S0me p@ssw0rd"
    }
    @tweet_attrs %{description: "some description", favorited: true, favorites: 42}

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

      {:ok, tweet} = TwitterDemo.Tweets.create_tweet(user, attrs)

      {tweet, user}
    end

    test "favo/2 makes user favoring tweet" do
      {tweet, user} = tweet_fixture()
      assert {:ok, %Favo{} = favo} = Favo.favo(tweet.id, user.id)
      assert tweet.id == favo.tweet_id
      assert user.id == favo.user_id
    end

    test "favoring?/2 returns whether user favoring tweet" do
      {tweet, user} = tweet_fixture()
      assert Favo.favoring?(tweet.id, user.id) == false
      assert {:ok, %Favo{}} = Favo.favo(tweet.id, user.id)
      assert Favo.favoring?(tweet.id, user.id) == true
    end

    test "unfavo/2 makes user unfavoring tweet" do
      {tweet, user} = tweet_fixture()
      assert {:ok, %Favo{}} = Favo.favo(tweet.id, user.id)
      assert {:ok, %Favo{}} = Favo.unfavo(tweet.id, user.id)
      assert Favo.favoring?(tweet.id, user.id) == false
    end
  end
end

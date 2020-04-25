defmodule TwitterDemo.RelationshipTest do
  use TwitterDemo.DataCase

  alias TwitterDemo.Relationship

  describe "relationship" do
    @user_attrs %{
      email: "some @email",
      name: "some name",
      password: "S0me p@ssw0rd"
    }

    @followed_attrs %{
      email: "other @email",
      name: "other name",
      password: "Other p@ssw0rd"
    }

    def user_fixture() do
      {:ok, user} =
        %{}
        |> Enum.into(@user_attrs)
        |> TwitterDemo.Users.create_user()

      {:ok, followed} =
        %{}
        |> Enum.into(@followed_attrs)
        |> TwitterDemo.Users.create_user()

      {user, followed}
    end

    test "follow/2 makes user follow other" do
      {user, followed} = user_fixture()
      assert {:ok, %Relationship{} = rel} = Relationship.follow(user.id, followed.id)
      assert user.id == rel.follower_id
      assert followed.id == rel.followed_id
    end

    test "following?/2 returns whether user following other" do
      {user, followed} = user_fixture()
      assert Relationship.following?(user.id, followed.id) == false
      assert {:ok, %Relationship{}} = Relationship.follow(user.id, followed.id)
      assert Relationship.following?(user.id, followed.id) == true
    end

    test "unfollow/2 makes user unfollow other" do
      {user, followed} = user_fixture()
      assert {:ok, %Relationship{}} = Relationship.follow(user.id, followed.id)
      assert {:ok, %Relationship{}} = Relationship.unfollow(user.id, followed.id)
      assert Relationship.following?(user.id, followed.id) == false
    end
  end
end

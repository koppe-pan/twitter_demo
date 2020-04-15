defmodule TwitterDemo.UsersTest do
  use TwitterDemo.DataCase

  alias TwitterDemo.Users

  describe "users" do
    alias TwitterDemo.Users.User

    @valid_attrs %{
      email: "some @email",
      introduction: "some introduction",
      name: "some name",
      password: "S0me p@ssw0rd"
    }
    @update_attrs %{
      email: "some updated @email",
      introduction: "some updated introduction",
      name: "some updated name",
      password: "S0me upd@ted p@ssw0rd"
    }
    @invalid_attrs %{email: nil, introduction: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = %{user_fixture() | password: nil}
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = %{user_fixture() | password: nil}
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.email == "some @email"
      assert user.introduction == "some introduction"
      assert user.name == "some name"

      {:ok, %User{} = temp_user} =
        User.find_and_confirm_password(@valid_attrs.email, @valid_attrs.password)

      assert user.password_hash == temp_user.password_hash
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.email == "some updated @email"
      assert user.introduction == "some updated introduction"
      assert user.name == "some updated name"

      {:ok, %User{} = temp_user} =
        User.find_and_confirm_password(@update_attrs.email, @update_attrs.password)

      assert user.password_hash == temp_user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = %{user_fixture() | password: nil}
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end

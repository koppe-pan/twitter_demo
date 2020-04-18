defmodule TwitterDemoWeb.ProfileControllerTest do
  use TwitterDemoWeb.ConnCase

  alias TwitterDemo.Users
  alias TwitterDemo.Users.User
  alias TwitterDemo.Relationship

  @follower_attrs %{
    email: "some @email",
    introduction: "some introduction",
    name: "some name",
    password: "S0me p@ssw0rd"
  }
  @followed_attrs %{
    email: "some followed @email",
    introduction: "some followed introduction",
    name: "some followed name",
    password: "S0me followed p@ssw0rd"
  }
  @invalid_attrs %{email: nil, introduction: nil, name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@followed_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok,
     conn: put_req_header(conn, "accept", "application/json"),
     followed: Users.create_user(@followed_attrs),
     follower: Users.create_user(@follower_attrs)}
  end

  describe "follow user" do
    test "renders Relationship when data is valid", %{
      conn: conn,
      follower: %User{name: follower_name, id: id} = _follower,
      followed: %User{name: followed_name} = _followed
    } do
      conn =
        post(conn, Routes.profile_path(conn, :follow),
          authorname: followed_name,
          id: id
        )

      assert %{
               "slug" => id,
               "username" => follower_name
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      follower: follower,
      followed: followed
    } do
      conn = post(conn, Routes.profile_path(conn, :follow), authorname: nil, id: follower.id)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end

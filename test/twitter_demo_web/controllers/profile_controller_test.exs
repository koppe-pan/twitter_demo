defmodule TwitterDemoWeb.ProfileControllerTest do
  use TwitterDemoWeb.ConnCase

  alias TwitterDemo.Users
  alias TwitterDemo.Users.User
  alias TwitterDemo.Relationship

  @user_attrs %{
    email: "some @email",
    name: "some name",
    password: "S0me p@ssw0rd"
  }
  @followed_attrs %{
    email: "some followed @email",
    introduction: "some followed introduction",
    name: "some followed name",
    password: "S0me followed p@ssw0rd"
  }

  #  @invalid_attrs %{email: nil, introduction: nil, name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@followed_attrs)
    user
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

    {:ok, followed} = Users.create_user(@followed_attrs)
    {:ok, conn: conn, user_id: user_id, followed: followed}
  end

  describe "show user" do
    test "show/2 shows inf of other", %{conn: conn, user_id: user_id, followed: followed} do
      Relationship.follow(user_id, followed.id)
      conn = get(conn, Routes.profile_path(conn, :show, "some followed name"))

      assert %{
               "name" => "some followed name",
               "following" => true,
               "introduction" => "some followed introduction"
             } = json_response(conn, 200)["profile"]
    end
  end

  describe "follow user" do
    test "renders Relationship when data is valid", %{
      conn: conn,
      followed: %User{name: followed_name} = _followed
    } do
      conn = post(conn, Routes.profile_path(conn, :follow, followed_name))

      assert %{
               "slug" => followed_id,
               "username" => followed_name
             } = json_response(conn, 201)
    end

    #    test "renders errors when data is invalid", %{
    #      conn: conn
    #    } do
    #      conn = post(conn, Routes.profile_path(conn, :follow, "invalid_name"))
    #      assert json_response(conn, 422)["errors"] != %{}
    #    end
  end

  describe "unfollow user" do
    test "delete Relationship when data is valid", %{
      conn: conn,
      followed: %User{id: _id, name: followed_name} = _followed
    } do
      conn =
        conn
        |> post(Routes.profile_path(conn, :follow, followed_name))
        |> recycle()
        |> delete(Routes.profile_path(conn, :unfollow, followed_name))

      assert response(conn, 204)
    end
  end
end

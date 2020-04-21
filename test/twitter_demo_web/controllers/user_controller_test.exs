defmodule TwitterDemoWeb.UserControllerTest do
  use TwitterDemoWeb.ConnCase

  alias TwitterDemo.Users
  alias TwitterDemo.Users.User

  @create_attrs %{
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

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  def authorize(conn, user = %User{}) do
    {:ok, jwt, _full_claims} = TwitterDemo.Guardian.encode_and_sign(user)
    {:ok, put_req_header(conn, "authorization", "Bearer " <> jwt)}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      {:ok, conn} = authorize(conn, user)
      conn = get(conn, Routes.user_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "email" => user.email,
                 "id" => user.id,
                 "introduction" => user.introduction,
                 "name" => user.name,
                 "password_hash" => user.password_hash
               }
             ]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{
               "name" => "some name"
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      {:ok, conn} = authorize(conn, user)
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      {:ok, %User{} = temp_user} =
        User.find_and_confirm_password(@update_attrs.email, @update_attrs.password)

      assert %{
               "id" => id,
               "email" => "some updated @email",
               "introduction" => "some updated introduction",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      {:ok, conn} = authorize(conn, user)
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      {:ok, conn} = authorize(conn, user)
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

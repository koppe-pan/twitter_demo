defmodule TwitterDemoWeb.UserController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Users
  alias TwitterDemo.Users.User

  action_fallback TwitterDemoWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, jwt, _claims} = TwitterDemo.Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("sign_up.json", user: user, jwt: jwt)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def get(conn, %{"name" => name}) do
    user = Users.get_by_name!(name)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def put(conn, %{"name" => name, "user" => user_params}) do
    user = Users.get_by_name!(name)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params),
         {:ok, jwt, _claims} = TwitterDemo.Guardian.encode_and_sign(user) do
      render(conn, "sign_up.json", user: user, jwt: jwt)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

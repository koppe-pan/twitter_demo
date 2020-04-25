defmodule TwitterDemoWeb.UserView do
  use TwitterDemoWeb, :view
  alias TwitterDemoWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("get.json", %{user: user}) do
    %{data: render_one(user, UserView, "profile.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("profile.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.name,
      password_hash: user.password_hash,
      introduction: user.introduction
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      password_hash: user.password_hash,
      introduction: user.introduction
    }
  end

  def render("sign_up.json", %{user: user, jwt: jwt}) do
    %{
      data: %{
        token: jwt,
        user: %{
          name: user.name,
          email: user.email,
          id: user.id
        }
      }
    }
  end
end

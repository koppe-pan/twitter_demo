defmodule TwitterDemoWeb.SessionView do
  use TwitterDemoWeb, :view

  def render("sign_in.json", %{user: user, jwt: jwt}) do
    %{data: %{token: jwt, name: user.name}}
  end

  def render("error.json", %{message: msg}) do
    %{error: msg}
  end
end

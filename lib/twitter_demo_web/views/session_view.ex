defmodule TwitterDemoWeb.SessionView do
  use TwitterDemoWeb, :view

  def render("sign_in.json", %{user: _user, jwt: jwt}) do
    %{token: jwt}
  end

  def render("error.json", %{message: msg}) do
    %{error: msg}
  end
end

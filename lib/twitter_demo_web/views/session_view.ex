defmodule TwitterDemoWeb.SessionView do
  use TwitterDemoWeb, :view

  def render("sign_in.json", %{user: user, jwt: jwt}) do
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

  def render("error.json", %{message: msg}) do
    %{error: msg}
  end
end

defmodule TwitterDemoWeb.SessionController do
  use TwitterDemoWeb, :controller

  alias TwitterDemo.Users.User

  def sign_in(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case User.find_and_confirm_password(email, password) do
      {:ok, user} ->
        with {:ok, jwt, _claims} = TwitterDemo.Guardian.encode_and_sign(user) do
          conn
          |> render("sign_in.json", user: user, jwt: jwt)
        end

      # {:ok, claims} = TwitterDemo.Guardian.decode_and_verify(jwt)
      # IO.inspect(claims)

      {:error, _reason} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Could not login")
    end
  end
end

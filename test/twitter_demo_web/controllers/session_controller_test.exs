defmodule TwitterDemoWeb.SessionControllerTest do
  use TwitterDemoWeb.ConnCase

  alias TwitterDemo.Users
  alias TwitterDemo.Users.User

  @create_attrs %{
    email: "some @email",
    introduction: "some introduction",
    name: "some name",
    password: "S0me p@ssw0rd"
  }

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "sign in" do
    setup [:create_user]

    test "returns token when data is valid", %{conn: conn, user: user} do
      conn =
        post(
          conn,
          Routes.session_path(conn, :sign_in),
          %{session: %{email: "some @email", password: "S0me p@ssw0rd"}}
        )

      {:ok, jwt, _full_claims} =
        user
        |> TwitterDemo.Guardian.encode_and_sign()

      assert jwt == json_response(conn, 200)["token"]
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

defmodule TwitterDemoWeb.Plugs.Auth do
  import Plug.Conn

  alias TwitterDemo.Guardian

  def init(default), do: default

  def call(conn, optional: true) do
    case auth_token(conn) do
      {:ok, identity} ->
        conn |> assign(:current_user, identity)

      _ ->
        conn
    end
  end

  def call(conn, only: :creator) do
    case auth_token(conn) do
      {:ok, %{is_creator: true} = identity} ->
        conn |> assign(:current_user, identity)

      _ ->
        conn |> halt_request
    end
  end

  def call(conn, only: :user) do
    case auth_token(conn) do
      {:ok, %{is_creator: false} = identity} ->
        conn |> assign(:current_user, identity)

      _ ->
        conn |> halt_request
    end
  end

  def call(conn, _) do
    case auth_token(conn) do
      {:ok, identity} ->
        conn |> assign(:current_user, identity)

      _ ->
        conn |> halt_request
    end
  end

  defp auth_token(conn) do
    with ["Bearer " <> access_token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Guardian.decode_and_verify(access_token, %{"typ" => "access"}),
         do: Guardian.resource_from_claims(claims)
  end

  defp halt_request(conn) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(401, Jason.encode!(%{"message" => "Unauthorized"}))
    |> halt
  end
end

defmodule TwitterDemoWeb.PageControllerTest do
  use TwitterDemoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "HomePage"
  end
end

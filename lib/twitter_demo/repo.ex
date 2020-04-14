defmodule TwitterDemo.Repo do
  use Ecto.Repo,
    otp_app: :twitter_demo,
    adapter: Ecto.Adapters.Postgres
end

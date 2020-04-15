# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :twitter_demo,
  ecto_repos: [TwitterDemo.Repo]

# Configures the endpoint
config :twitter_demo, TwitterDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SOwYCZksr3S3MPnXwP/gJJkOjLkJfl6eIaud8KT7p+uoed+3IWKSj02hyGuV+efU",
  render_errors: [view: TwitterDemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TwitterDemo.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Guardian
config :twitter_demo, TwitterDemo.Guardian,
  issuer: "twitter_demo",
  secret_key: "PMe2czX4/ODOUj7VWO/WYsD9IUlGwMgZx8sZOKY0JbmvXgnfR22uOUiBhkbpjNIQ"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

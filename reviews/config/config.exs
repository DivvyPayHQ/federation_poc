# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :reviews, ReviewsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RGClRodBh4Er4AjAW9n6Xvyjay6LWQ60EjdOKz+dJ8/XAaLwopBH3YD2L1nDrzIB",
  render_errors: [view: ReviewsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Reviews.PubSub,
  live_view: [signing_salt: "e2AttXK6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

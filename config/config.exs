# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :flagme,
  ecto_repos: [Flagme.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :flagme, FlagmeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: FlagmeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Flagme.PubSub,
  live_view: [signing_salt: "e1PYcJJj"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :flagme, Flagme.Repo, migration_primary_key: [name: :id, type: :binary_id]

config :flagme, Flagme.Guardian,
  issuer: "flagme",
  secret_key: "mysecretkey",
  permissions: %{
    read_only: [:read_flags],
    default: [:read_flags, :create_flags, :update_flags],
    admin: [:delete_flags, :manage_users]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

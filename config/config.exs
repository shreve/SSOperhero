# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sso,
  ecto_repos: [SSO.Repo],
  token_lifetime: (System.get_env("SSO_TOKEN_LIFETIME") || "3600") |> Integer.parse |> elem(0)

# Configures the endpoint
config :sso, SSO.Endpoint,
  url: [host: System.get_env("SSO_DOMAIN") || "phoenix.dev"],
  secret_key_base: "wMVsmzpl8I3cge86Csh84Ds6vpyF6s4CIfynx61GpI10+JARETF8Q5PDSOceZhTf",
  render_errors: [view: SSO.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SSO.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Enable .slim and .slime templates to be rendered
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :ex_admin,
  repo: SSO.Repo,
  module: SSO,
  modules: [
    SSO.ExAdmin.Dashboard,
    SSO.ExAdmin.User,
    SSO.ExAdmin.Client,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

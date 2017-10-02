# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, Discuss.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "u4ZxbxsB5cVBal2NCrcwlNOgRBIv0b4Mpvd5aBJD3KljHfZTg5rEGJET3Mk0azFn",
  render_errors: [view: Discuss.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# ADD GITHUB TO YOUR ÜBERAUTH CONFIGURATION:
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ]

# UPDATE YOUR PROVIDER CONFIGURATION:
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# INCLUDE THE uBERAUTH PLUG IN YOUR CONTROLLER:
# defmodule MyApp.AuthController do
#   use MyApp.Web, :controller

#   pipeline :browser do
#     plug Ueberauth
#     ...
#   end
# end

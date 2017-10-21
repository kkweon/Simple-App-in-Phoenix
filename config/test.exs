use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mango, MangoWeb.Endpoint,
  http: [port: 4001],
  # Needed to test the server
  server: true

config :hound, driver: "phantomjs", host: (System.get_env("PHANTOMJS_HOST") || "localhost"), port: 8910

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :mango, Mango.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USERNAME") || "postgres",
  password: System.get_env("DB_PASSWORD") || "postgres",
  database: System.get_env("DB_TEST_NAME") || "mango_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

import Config

config :rockelivery, Rockelivery.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "rockelivery_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

if System.get_env("GITHUB_ACTIONS") do
  config :rockelivery, Rockelivery.Repo,
    username: "postgres",
    password: "postgres"
end

config :rockelivery, RockeliveryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "h6TJuXk+NMzig0v3LAYKAA2hoa5/ixCJelSg3NkAdxSR7ecB45fxMq5voqoCvoex",
  server: false

config :rockelivery, Rockelivery.Users.Create, via_cep_adapter: Rockelivery.ViaCep.ClientMock

config :rockelivery, Rockelivery.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

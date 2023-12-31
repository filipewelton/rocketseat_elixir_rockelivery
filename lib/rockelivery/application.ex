defmodule Rockelivery.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RockeliveryWeb.Telemetry,
      Rockelivery.Repo,
      {DNSCluster, query: Application.get_env(:rockelivery, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Rockelivery.PubSub},
      {Finch, name: Rockelivery.Finch},
      RockeliveryWeb.Endpoint,
      Rockelivery.Orders.ReportRunner
    ]

    opts = [strategy: :one_for_one, name: Rockelivery.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    RockeliveryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Luanox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LuanoxWeb.Telemetry,
      Luanox.Repo,
      {DNSCluster, query: Application.get_env(:backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Luanox.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Luanox.Finch},
      # Start a worker by calling: Luanox.Worker.start_link(arg)
      # {Luanox.Worker, arg},
      # Start to serve requests, typically the last entry
      LuanoxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Luanox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LuanoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

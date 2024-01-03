defmodule Charades.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CharadesWeb.Telemetry,
      Charades.Repo,
      {DNSCluster, query: Application.get_env(:charades, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Charades.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Charades.Finch},
      # Start a worker by calling: Charades.Worker.start_link(arg)
      # {Charades.Worker, arg},
      # Start to serve requests, typically the last entry
      CharadesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Charades.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CharadesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

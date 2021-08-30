defmodule Inventory.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      InventoryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Inventory.PubSub},
      # Start the Endpoint (http/https)
      InventoryWeb.Endpoint
      # Start a worker by calling: Inventory.Worker.start_link(arg)
      # {Inventory.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Inventory.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InventoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule TodoApplication.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TodoApplication.Repo,
      # Start the Telemetry supervisor
      TodoApplicationWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TodoApplication.PubSub},
      # Start the Endpoint (http/https)
      TodoApplicationWeb.Endpoint
      # Start a worker by calling: TodoApplication.Worker.start_link(arg)
      # {TodoApplication.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodoApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodoApplicationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

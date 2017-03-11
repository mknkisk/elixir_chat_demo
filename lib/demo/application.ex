defmodule Demo.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Demo.Worker.start_link(arg1, arg2, arg3)
      # worker(Demo.Worker, [arg1, arg2, arg3]),
      worker(__MODULE__, [], function: :start_cowboy)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Start cowboy
  # ref: https://ninenines.eu/docs/en/cowboy/2.0/manual/cowboy_router.compile/
  # ref: https://ninenines.eu/docs/en/cowboy/2.0/manual/cowboy.start_clear/
  # ref: https://ninenines.eu/docs/en/cowboy/2.0/manual/cowboy_static/
  #
  def start_cowboy do
    # Routing
    routes = [
      {"/", Demo.HelloHandler, []},
      {"/greet/:name", Demo.GreetHandler, []},
      {"/static/[...]", :cowboy_static, {:priv_dir, :demo, "static_files"}}
    ]
    dispatch = :cowboy_router.compile([{:_, routes}])
    opts = [{:port, 4000}]
    env = %{dispatch: dispatch}
    {:ok, _pid} = :cowboy.start_clear(
                    :http,       # Listener name
                    10,          # Number of process
                    opts,        # Transport options (port number etc...)
                    %{env: env})
  end
end

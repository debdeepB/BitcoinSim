defmodule BitcoinsimWeb.SimulationController do
  use BitcoinsimWeb, :controller

  alias Bitcoinsim.Simulations
  alias Bitcoinsim.Simulations.Simulation

  def index(conn, _params) do
    simulation = Simulations.list_simulation()
    render(conn, "index.html", simulation: simulation)
  end

  def new(conn, _params) do
    changeset = Simulations.change_simulation(%Simulation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"simulation" => simulation_params}) do
    case Simulations.create_simulation(simulation_params) do
      {:ok, simulation} ->
        conn
        |> put_flash(:info, "Simulation created successfully.")
        |> redirect(to: simulation_path(conn, :show, simulation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    simulation = Simulations.get_simulation!(id)
    render(conn, "show.html", simulation: simulation)
  end

  def edit(conn, %{"id" => id}) do
    simulation = Simulations.get_simulation!(id)
    changeset = Simulations.change_simulation(simulation)
    render(conn, "edit.html", simulation: simulation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "simulation" => simulation_params}) do
    simulation = Simulations.get_simulation!(id)

    case Simulations.update_simulation(simulation, simulation_params) do
      {:ok, simulation} ->
        conn
        |> put_flash(:info, "Simulation updated successfully.")
        |> redirect(to: simulation_path(conn, :show, simulation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", simulation: simulation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    simulation = Simulations.get_simulation!(id)
    {:ok, _simulation} = Simulations.delete_simulation(simulation)

    conn
    |> put_flash(:info, "Simulation deleted successfully.")
    |> redirect(to: simulation_path(conn, :index))
  end

  def run(conn, %{"id" => id}) do
    simulation = Simulations.get_simulation!(id)
    Runner.run(simulation)
    conn
    |> put_flash(:info, "Simulation started successfully.")
    |> redirect(to: simulation_path(conn, :show, simulation))
  end
end

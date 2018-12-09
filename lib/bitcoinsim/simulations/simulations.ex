defmodule Bitcoinsim.Simulations do
  @moduledoc """
  The Simulations context.
  """

  import Ecto.Query, warn: false
  alias Bitcoinsim.Repo

  alias Bitcoinsim.Simulations.Simulation

  @doc """
  Returns the list of simulation.

  ## Examples

      iex> list_simulation()
      [%Simulation{}, ...]

  """
  def list_simulation do
    Repo.all(Simulation)
  end

  @doc """
  Gets a single simulation.

  Raises `Ecto.NoResultsError` if the Simulation does not exist.

  ## Examples

      iex> get_simulation!(123)
      %Simulation{}

      iex> get_simulation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_simulation!(id), do: Repo.get!(Simulation, id)

  @doc """
  Creates a simulation.

  ## Examples

      iex> create_simulation(%{field: value})
      {:ok, %Simulation{}}

      iex> create_simulation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_simulation(attrs \\ %{}) do
    %Simulation{}
    |> Simulation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a simulation.

  ## Examples

      iex> update_simulation(simulation, %{field: new_value})
      {:ok, %Simulation{}}

      iex> update_simulation(simulation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_simulation(%Simulation{} = simulation, attrs) do
    simulation
    |> Simulation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Simulation.

  ## Examples

      iex> delete_simulation(simulation)
      {:ok, %Simulation{}}

      iex> delete_simulation(simulation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_simulation(%Simulation{} = simulation) do
    Repo.delete(simulation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking simulation changes.

  ## Examples

      iex> change_simulation(simulation)
      %Ecto.Changeset{source: %Simulation{}}

  """
  def change_simulation(%Simulation{} = simulation) do
    Simulation.changeset(simulation, %{})
  end
end

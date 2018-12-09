defmodule Bitcoinsim.SimulationsTest do
  use Bitcoinsim.DataCase

  alias Bitcoinsim.Simulations

  describe "simulation" do
    alias Bitcoinsim.Simulations.Simulation

    @valid_attrs %{miners: 42, mining_reward: 120.5, name: "some name", peers: 42}
    @update_attrs %{miners: 43, mining_reward: 456.7, name: "some updated name", peers: 43}
    @invalid_attrs %{miners: nil, mining_reward: nil, name: nil, peers: nil}

    def simulation_fixture(attrs \\ %{}) do
      {:ok, simulation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Simulations.create_simulation()

      simulation
    end

    test "list_simulation/0 returns all simulation" do
      simulation = simulation_fixture()
      assert Simulations.list_simulation() == [simulation]
    end

    test "get_simulation!/1 returns the simulation with given id" do
      simulation = simulation_fixture()
      assert Simulations.get_simulation!(simulation.id) == simulation
    end

    test "create_simulation/1 with valid data creates a simulation" do
      assert {:ok, %Simulation{} = simulation} = Simulations.create_simulation(@valid_attrs)
      assert simulation.miners == 42
      assert simulation.mining_reward == 120.5
      assert simulation.name == "some name"
      assert simulation.peers == 42
    end

    test "create_simulation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Simulations.create_simulation(@invalid_attrs)
    end

    test "update_simulation/2 with valid data updates the simulation" do
      simulation = simulation_fixture()
      assert {:ok, simulation} = Simulations.update_simulation(simulation, @update_attrs)
      assert %Simulation{} = simulation
      assert simulation.miners == 43
      assert simulation.mining_reward == 456.7
      assert simulation.name == "some updated name"
      assert simulation.peers == 43
    end

    test "update_simulation/2 with invalid data returns error changeset" do
      simulation = simulation_fixture()
      assert {:error, %Ecto.Changeset{}} = Simulations.update_simulation(simulation, @invalid_attrs)
      assert simulation == Simulations.get_simulation!(simulation.id)
    end

    test "delete_simulation/1 deletes the simulation" do
      simulation = simulation_fixture()
      assert {:ok, %Simulation{}} = Simulations.delete_simulation(simulation)
      assert_raise Ecto.NoResultsError, fn -> Simulations.get_simulation!(simulation.id) end
    end

    test "change_simulation/1 returns a simulation changeset" do
      simulation = simulation_fixture()
      assert %Ecto.Changeset{} = Simulations.change_simulation(simulation)
    end
  end
end

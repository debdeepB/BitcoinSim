defmodule BitcoinsimWeb.SimulationControllerTest do
  use BitcoinsimWeb.ConnCase

  alias Bitcoinsim.Simulations

  @create_attrs %{miners: 42, mining_reward: 120.5, name: "some name", peers: 42}
  @update_attrs %{miners: 43, mining_reward: 456.7, name: "some updated name", peers: 43}
  @invalid_attrs %{miners: nil, mining_reward: nil, name: nil, peers: nil}

  def fixture(:simulation) do
    {:ok, simulation} = Simulations.create_simulation(@create_attrs)
    simulation
  end

  describe "index" do
    test "lists all simulation", %{conn: conn} do
      conn = get conn, simulation_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Simulation"
    end
  end

  describe "new simulation" do
    test "renders form", %{conn: conn} do
      conn = get conn, simulation_path(conn, :new)
      assert html_response(conn, 200) =~ "New Simulation"
    end
  end

  describe "create simulation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, simulation_path(conn, :create), simulation: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == simulation_path(conn, :show, id)

      conn = get conn, simulation_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Simulation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, simulation_path(conn, :create), simulation: @invalid_attrs
      assert html_response(conn, 200) =~ "New Simulation"
    end
  end

  describe "edit simulation" do
    setup [:create_simulation]

    test "renders form for editing chosen simulation", %{conn: conn, simulation: simulation} do
      conn = get conn, simulation_path(conn, :edit, simulation)
      assert html_response(conn, 200) =~ "Edit Simulation"
    end
  end

  describe "update simulation" do
    setup [:create_simulation]

    test "redirects when data is valid", %{conn: conn, simulation: simulation} do
      conn = put conn, simulation_path(conn, :update, simulation), simulation: @update_attrs
      assert redirected_to(conn) == simulation_path(conn, :show, simulation)

      conn = get conn, simulation_path(conn, :show, simulation)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, simulation: simulation} do
      conn = put conn, simulation_path(conn, :update, simulation), simulation: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Simulation"
    end
  end

  describe "delete simulation" do
    setup [:create_simulation]

    test "deletes chosen simulation", %{conn: conn, simulation: simulation} do
      conn = delete conn, simulation_path(conn, :delete, simulation)
      assert redirected_to(conn) == simulation_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, simulation_path(conn, :show, simulation)
      end
    end
  end

  defp create_simulation(_) do
    simulation = fixture(:simulation)
    {:ok, simulation: simulation}
  end
end

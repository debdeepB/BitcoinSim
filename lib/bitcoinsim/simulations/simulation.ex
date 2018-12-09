defmodule Bitcoinsim.Simulations.Simulation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "simulation" do
    field :miners, :integer
    field :mining_reward, :float
    field :name, :string
    field :peers, :integer

    timestamps()
  end

  @doc false
  def changeset(simulation, attrs) do
    simulation
    |> cast(attrs, [:name, :peers, :miners, :mining_reward])
    |> validate_required([:name, :peers, :miners, :mining_reward])
  end
end

defmodule Bitcoinsim.Repo.Migrations.CreateSimulation do
  use Ecto.Migration

  def change do
    create table(:simulation) do
      add :name, :string
      add :peers, :integer
      add :miners, :integer
      add :mining_reward, :float

      timestamps()
    end

  end
end

defmodule BitcoinsimWeb.SimulationChannel do
  use Phoenix.Channel

  def join("simulation:basic", _message, socket) do
    {:ok, socket}
  end
  
end
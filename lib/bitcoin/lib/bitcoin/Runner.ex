defmodule Runner do
  
  def run(simulation) do
    BitcoinsimWeb.Endpoint.broadcast("simulation:basic", "new_msg", %{payload: "payload"})
    IO.inspect simulation
  end


end
defmodule BitcoinsimWeb.SimulationChannel do
  use Phoenix.Channel

  def join("simulation:basic", _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end
  
end
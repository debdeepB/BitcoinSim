defmodule PendingTransactions do
  use GenServer

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def add(pid, tx) do
    GenServer.cast(pid, {:add, tx})
  end

  def get_pending_transactions(pid) do
    GenServer.call(pid, :get_all)
  end

  def reset(pid) do
    GenServer.call(pid, :reset)
  end

  @impl true
  def init(queue) do
    {:ok, queue}
  end

  @impl true
  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, [], []}
  end

  @impl true
  def handle_cast({:add, tx}, state) do
    {:noreply, state ++ [tx]}
  end
  
end
defmodule Peer do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def perform_transaction(pid, {to_address, amount}) do
    GenServer.cast(pid, {:perform_transaction, to_address, amount})
  end

  def mine(pid) do
    GenServer.cast(pid, {:mine})
  end

  def validate(pid, block) do
    GenServer.cast(pid, {:validate, block})
  end

  def init(state) do
    state = Map.put(state, :keypair, CryptoUtils.generate_keypair)
    {:ok, state}
  end

  def handle_cast({:perform_transaction, to_address, amount}, state) do
    tx = Transaction.create_transaction(state.keypair.public_key, to_address, amount)
    tx = Transaction.sign_transaction(tx, state.keypair)
    Blockchain.add_transaction(:global.whereis_name("pending_transactions"), tx)
    {:noreply, state}
  end

  def handle_cast({:mine}, state) do
    mined_block = Blockchain.mine_pending_transactions(:global.whereis_name("pending_transactions"),
                                                      state.keypair.public_key,
                                                      List.last(state.blockchain).hash)
    # broadcast this block to all peers
    num_peers = 3
    Enum.each(1..num_peers, fn id ->
      Peer.validate(:global.whereis_name("peer-" <> Integer.to_string(id)), mined_block)
    end)
    PendingTransactions.reset(:global.whereis_name("pending_transactions"))
    {:noreply, state}
  end

  def handle_cast({:validate, block}, state) do
    state = if (Block.has_valid_transactions(block)) do
      Map.put(state, :blockchain, state.blockchain ++ [block])
    end
    {:noreply, state}
  end
end
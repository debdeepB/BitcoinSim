defmodule Runner do
  
  def run(simulation) do
    IO.inspect simulation
    genesis_block = Block.create_genesis_block
    initial_state = %{
      blockchain: [genesis_block],
      keypair: %{}
    }
    {:ok, pending_transactions} = PendingTransactions.start_link([])
    :global.register_name("pending_transactions", pending_transactions)
    init_peers(simulation.peers, initial_state)
    loop(simulation, 1000)
  end

  defp init_peers(num_peers, initial_state) do
    if num_peers > 0 do
      {:ok, pid} = Peer.start_link(initial_state)
      peer_name = "peer-#{num_peers}"
      :global.register_name(peer_name, pid)
      # everyone mines so that everyone gets a reward
      Peer.mine(pid)
      init_peers(num_peers - 1, initial_state)
    end
  end

  defp loop(simulation, iterations) do
    if iterations > 0 do
      miner_id = :rand.uniform(simulation.peers)
      random_miner = :global.whereis_name("peer-"<>Integer.to_string(miner_id))
      Peer.mine(random_miner)
      peer1 = :global.whereis_name("peer-"<>Integer.to_string(:rand.uniform(simulation.peers)))
      peer2 = :global.whereis_name("peer-"<>Integer.to_string(:rand.uniform(simulation.peers)))
      if (peer1 != peer2) do
        amount = :rand.uniform(10)/1
        Peer.perform_transaction(peer1, {:sys.get_state(peer2).keypair.public_key, amount})
        :timer.sleep(500)
      end
      loop(simulation, iterations - 1)
    end
  end

end
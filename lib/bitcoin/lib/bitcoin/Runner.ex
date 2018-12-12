defmodule Runner do
  
  def run(simulation) do
    BitcoinsimWeb.Endpoint.broadcast("simulation:basic", "new_msg", %{payload: "payload"})

    IO.inspect simulation

    genesis_block = Block.create_genesis_block
    initial_state = %{
      blockchain: [genesis_block],
      keypair: %{}
    }
    {:ok, pending_transactions} = PendingTransactions.start_link([])
    :global.register_name("pending_transactions", pending_transactions)
    {:ok, peer1} = Peer.start_link(initial_state)
    {:ok, peer2} = Peer.start_link(initial_state)
    {:ok, peer3} = Peer.start_link(initial_state)
    :global.register_name("peer-1", peer1)
    :global.register_name("peer-2", peer2)
    :global.register_name("peer-3", peer3)
    Peer.mine(peer1)
    amount = 5.0
    Peer.perform_transaction(peer1, {:sys.get_state(peer2).keypair.public_key, amount})
  end


end
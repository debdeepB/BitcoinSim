# start the simulation
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
:timer.sleep(1000)
bc = :sys.get_state(peer1).blockchain
peer1_balance = Blockchain.get_balance_of_address(bc, :sys.get_state(peer1).keypair.public_key)
peer2_balance = Blockchain.get_balance_of_address(bc, :sys.get_state(peer2).keypair.public_key)
# send some btc's to peer2
amount = 5.0
Peer.perform_transaction(peer1, {:sys.get_state(peer2).keypair.public_key, amount})
Peer.mine(peer3)
:timer.sleep(1000)
bc = :sys.get_state(peer1).blockchain
:timer.sleep(1000)

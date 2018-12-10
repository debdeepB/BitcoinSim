defmodule Bitcoin.BlockChainTest do
  use ExUnit.Case, async: true

  setup do
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
    %{ peer1: peer1, peer2: peer2, peer3: peer3, pending_transactions: pending_transactions}
  end

  test "Mine a valid block and see if it is reflected in their blockchain", %{ peer1: peer1, peer2: peer2, peer3: peer3, pending_transactions: pending_transactions} do
    Peer.mine(peer1)
    :timer.sleep(1000)
    assert :sys.get_state(pending_transactions) == []
    blockchain1 = :sys.get_state(peer1).blockchain
    blockchain2 = :sys.get_state(peer2).blockchain
    blockchain3 = :sys.get_state(peer3).blockchain
    assert blockchain1 == blockchain2
  end

  test "check if the blockchain is valid", %{ peer1: peer1, peer2: peer2, peer3: peer3, pending_transactions: pending_transactions} do
    blockchain = :sys.get_state(peer1).blockchain
    assert Blockchain.is_valid(blockchain) == true
  end

  test "check if the blockchain is invalid when tampered", %{ peer1: peer1, peer2: peer2, peer3: peer3, pending_transactions: pending_transactions} do
    Peer.mine(peer2)
    :timer.sleep(1000)
    blockchain = :sys.get_state(peer1).blockchain
    block = Enum.at(blockchain, -1)
    tampered_block = Map.put(block, :timestamp, 1)
    tampered_blockchain = List.replace_at(blockchain, -1, tampered_block)
    assert Blockchain.is_valid(tampered_blockchain) == false
  end

  test "check wallet of an address", %{ peer1: peer1, peer2: peer2, peer3: peer3, pending_transactions: pending_transactions} do
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
    assert Blockchain.get_balance_of_address(bc, :sys.get_state(peer1).keypair.public_key) == peer1_balance - amount
    assert Blockchain.get_balance_of_address(bc, :sys.get_state(peer2).keypair.public_key) == peer2_balance + amount
  end

  test "check reward of an address", %{ peer1: peer1, peer2: peer2, peer3: peer3, pending_transactions: pending_transactions} do
    bc = :sys.get_state(peer1).blockchain
    peer1_balance = Blockchain.get_balance_of_address(bc, :sys.get_state(peer1).keypair.public_key)
    Peer.mine(peer1)
    :timer.sleep(1000)
    bc = :sys.get_state(peer1).blockchain
    reward_amount = 1000.0
    assert Blockchain.get_balance_of_address(bc, :sys.get_state(peer1).keypair.public_key) == peer1_balance + reward_amount
  end

end
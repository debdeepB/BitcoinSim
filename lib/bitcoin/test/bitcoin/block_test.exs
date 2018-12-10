defmodule Bitcoin.BlockTest do
  use ExUnit.Case, async: true

  setup do
    genesis_block = Block.create_genesis_block
    keypair1 = CryptoUtils.generate_keypair
    keypair2 = CryptoUtils.generate_keypair
    tx1 = Transaction.create_transaction(keypair1.public_key, keypair2.public_key, 9.0)
    tx1 = Transaction.sign_transaction(tx1, keypair1)
    tx2 = Transaction.create_transaction(keypair2.public_key, keypair1.public_key, 3.0)
    tx2 = Transaction.sign_transaction(tx2, keypair2)
    transactions = [tx1, tx2]
    block = Block.create_block(100, transactions, genesis_block.hash)
    %{genesis_block: genesis_block,
      block: block,
      transactions: transactions,
      keypair1: keypair1,
      keypair2: keypair2
    }
  end

  test "Checks whether genesis block was created correctly", %{genesis_block: genesis_block} do
    assert genesis_block.transactions == []
    assert genesis_block.nonce == 0
  end

  test "Checks whether block was created correctly", %{genesis_block: genesis_block, block: block, transactions: transactions} do
    assert block.transactions == transactions
    assert block.previous_hash == genesis_block.hash
  end

  test "Checks whether block can be tampered with:", %{block: block} do
    tampered_block_1 = Map.put(block, :timestamp, -1)
    assert Block.calculate_hash(tampered_block_1) != block.hash

    tampered_block_2 = Map.put(block, :nonce, -1)
    assert Block.calculate_hash(tampered_block_2) != block.hash
  end

  test "Checks whether block transactions can be tampered with:", %{block: block} do
    transactions = block.transactions
    tampered_tx = Map.put(Enum.at(transactions,0), :amount, 1000.0)
    tampered_txs = List.replace_at(transactions, 0, tampered_tx)
    tampered_block = Map.put(block, :transactions, tampered_txs)
    assert Block.has_valid_transactions(tampered_block) == false
    assert Block.calculate_hash(tampered_block) != block.hash
  end

  test "Checks whether block is mined properly", %{block: block} do
    mined_block = Block.mine_block(block)
    assert String.starts_with?(mined_block.hash, "00") == true
  end
end
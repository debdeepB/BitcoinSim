defmodule Bitcoin.TransactionTest do
  use ExUnit.Case, async: true

  setup do
    keypair1 = CryptoUtils.generate_keypair
    keypair2 = CryptoUtils.generate_keypair
    tx1 = Transaction.create_transaction(keypair1.public_key, keypair2.public_key, 9.0)
    tx1 = Transaction.sign_transaction(tx1, keypair1)
    tx2 = Transaction.create_transaction(keypair2.public_key, keypair1.public_key, 3.0)
    tx2 = Transaction.sign_transaction(tx2, keypair2)
    %{tx1: tx1,
      tx2: tx2,
      keypair1: keypair1,
      keypair2: keypair2
    }
  end

  test "Checks whether transactions were created correctly", %{tx1: tx1, tx2: tx2, keypair1: keypair1, keypair2: keypair2} do
    assert tx1.from_address == keypair1.public_key
    assert tx1.to_address == keypair2.public_key
    assert tx1.amount == 9.0
    assert tx1.signature != ""
  end

  test "Checks whether transaction is valid", %{tx1: tx1, tx2: tx2} do
    assert Transaction.is_valid(tx1) == true
    assert Transaction.is_valid(tx2) == true
  end

  test "Checks whether transaction is invalid if tampered", %{tx1: tx1, tx2: tx2} do
    tampered_tx1 = Map.put(tx1, :amount, 1000000.0)
    tampered_tx2 = Map.put(tx2, :from_address, "AB")
    assert Transaction.is_valid(tampered_tx1) == false
    assert Transaction.is_valid(tampered_tx2) == false
  end

  test "Checks whether transaction is being signed properly", %{keypair1: keypair1, keypair2: keypair2} do
    tx = Transaction.create_transaction(keypair1.public_key, keypair2.public_key, 100.0)
    tx = Transaction.sign_transaction(tx, keypair1)
    tx_hash = Transaction.calculate_hash(tx)
    assert CryptoUtils.verify(tx.from_address, tx.signature, tx_hash)
  end

end
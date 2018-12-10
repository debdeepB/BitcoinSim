defmodule Transaction do
  def create_transaction(from_address, to_address, amount) do
    %{
      from_address: from_address,
      to_address: to_address,
      amount: amount,
      timestamp: :os.system_time(:millisecond),
      signature: ""
    }
  end

  def sign_transaction(tx, keypair) do
    if keypair.public_key != tx.from_address do
      IO.puts "Error: Not your wallet!"
    else
      hash = calculate_hash(tx)
      signature = CryptoUtils.sign(keypair, hash)
      tx = Map.put(tx, :signature, signature)
      tx
    end
  end

  def is_valid(tx) do
    cond do
      tx.from_address == "" ->
        true
      tx.signature == "" ->
        IO.puts "Error: Transaction hasn't been signed"
        false
      true ->
        tx_hash = calculate_hash(tx)
        CryptoUtils.verify(tx.from_address, tx.signature, tx_hash)
    end
  end
  
  def calculate_hash(tx) do
    tx.from_address <> tx.to_address <> Float.to_string(tx.amount) <> Integer.to_string(tx.timestamp) |> CryptoUtils.calculate_hash
  end
end
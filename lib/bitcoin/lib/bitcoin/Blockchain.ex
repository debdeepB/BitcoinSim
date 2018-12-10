defmodule Blockchain do
  def add_transaction(pending_transaction_pid, tx) do
    cond do
      tx.from_address == "" or tx.to_address == "" ->
        {:error, "No from or to address in transaction"}
      !Transaction.is_valid(tx) ->
        {:error, "Invalid transaction"}
      true ->
        PendingTransactions.add(pending_transaction_pid, tx)
    end
  end

  # mine pending transactions and get the mined block in return
  def mine_pending_transactions(pending_transaction_pid, mining_reward_address, previous_hash) do
    reward_amount = 1000.0
    reward_tx = Transaction.create_transaction("", 
                                              mining_reward_address,
                                              reward_amount)
    PendingTransactions.add(pending_transaction_pid, reward_tx)

    block = Block.create_block(:os.system_time(:millisecond),
                                PendingTransactions.get_pending_transactions(pending_transaction_pid),
                                previous_hash
                                )
    Block.mine_block(block)
  end

  def is_valid([prev_block | [curr_block | tail]]) do
    cond do
      curr_block.previous_hash != prev_block.hash ->
        false
      !Block.has_valid_transactions(curr_block) ->
        false
      Block.calculate_hash(curr_block) != curr_block.hash ->
        false
      true ->
        is_valid([curr_block | tail])
    end
  end

  def is_valid([]), do: true

  def is_valid([block | []]) do
    Block.has_valid_transactions(block)
  end

  def get_balance_of_address(blockchain, address) do
    Enum.reduce(blockchain, 0, fn block, acc -> acc + get_balance_block(block, address) end)
  end

  def get_balance_block(block, address) do
    Enum.reduce(block.transactions, 0, fn tx, acc ->
      cond do
        tx.from_address == address ->
          acc - tx.amount
        tx.to_address == address ->
          acc + tx.amount
        true ->
          acc
      end
    end)
  end

end
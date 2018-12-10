defmodule Bitcoin.CryptoUtilsTest do
  use ExUnit.Case, async: true

  setup do
    keypair1 = CryptoUtils.generate_keypair
    keypair2 = CryptoUtils.generate_keypair
    message = "A1"
    %{keypair1: keypair1, keypair2: keypair2, message: message}
  end

  test "checks if hash is calculated properly", %{message: message} do
    assert CryptoUtils.calculate_hash(message) == "1FFD4BA3EB9FFADF4DB3C3FF4C1BBCF94A64CC59"
  end

  test "checks if message is signed and verified properly", %{keypair1: keypair1, keypair2: keypair2, message: message} do
    signature = CryptoUtils.sign(keypair1, message)
    assert CryptoUtils.verify(keypair1.public_key, signature, message) == true
    assert CryptoUtils.verify(keypair2.public_key, signature, message) == false
  end


end
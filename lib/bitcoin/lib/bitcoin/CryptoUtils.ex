defmodule CryptoUtils do
  
  def generate_keypair() do
    {public_key, private_key} = :crypto.generate_key(:ecdh, :secp256k1)
    %{
      public_key: Base.encode16(public_key),
      private_key: Base.encode16(private_key)
    }
  end

  def sign(keypair, message) do
    :crypto.sign(:ecdsa, :sha256, Base.decode16!(message), [Base.decode16!(keypair.private_key), :secp256k1]) |> Base.encode16
  end

  def verify(public_key, signature, message) do
    :crypto.verify(:ecdsa, :sha256, Base.decode16!(message), Base.decode16!(signature), [Base.decode16!(public_key), :secp256k1])
  end

  def calculate_hash(data) do
    :crypto.hash(:sha, data) |> Base.encode16
  end
  
end
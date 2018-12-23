# Bitcoinsim

youtube url of the demo: https://www.youtube.com/watch?v=ggXe7i-YPL0&feature=youtu.be

## Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

# Features

This is a phoenix web app which uses websockets to provide realtime graphs and stats for a bitcoin simulation. Several parameters of the simulation can be adjusted.

Chart.js is used as a graphing library for plotting the graphs.

Metrics displayed -

transactions-completed  
blocks-mined  
transactions-per-second  
blocks-mined-per-second  
transactions-per-block

All of these are displayed realtime in a chart along with the transaction ledger where transactions are added and are cleared (whenever a block is mined).

Initially, 100 peers are spawned (depends on user input). All of the peers randomly transact random number of bitcoins with each other. Random peers start mining and mine blocks. Each peer has their own copy of the blockchain. Whenever a new block gets mined, it is broadcasted to all other peers and is validated by everyone. Only then is it added to the blockchain.

## Blockchain Features

### Crypto Features

Every Peer would have it's own public and private key. While signing a transaction, the peer signs it with it's private key and while verifying a transaction it is done with the public key given in the from_address field in the transaction. The erlang crypto library is used for signing and verification and hashing and the elliptic curve secp256k1 is used as is given in the bitcoin documentation.

### Mine Bitcoins

A peer can mine bitcoins. The difficulty threshold is kept at 2 leading 0's but can be increased to any arbitary number. A mining reward is given to the peer who mines a block succesfully.

### Implement Wallets

Wallets are implemented and peers in the network can check their balance.

### Transact Bitcoins

Peers can perform transactions after digitally signing them and send bitcoins to each other. Everything gets recorded in the transaction ledger (PendingTransactions)which gets mined when a peer mines a new block.


## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

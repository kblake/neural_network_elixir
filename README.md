# Neural Network

A neural network made up of layers of neurons connected to each other to form a relationship allowing it to learn. This network is still a work in progress but is far enough along to get an idea of how it works. This is a reimplementation of what was started here: [https://github.com/kblake/neural-net-elixir-v1](https://github.com/kblake/neural-net-elixir-v1).

After cloning:

    $ mix compile

## Usage

Run the trainer and see the network learn using OR GATE data

    $ mix learn or

You should see output like this:
    
    $ Epoch: 0   Error: 0.0978034950879825143
    Epoch: 1000   Error: 0.0177645755625382047
    Epoch: 2000   Error: 0.0065019384961036274
    Epoch: 3000   Error: 0.0032527653252166144
    Epoch: 4000   Error: 0.0019254900093371497
    Epoch: 5000   Error: 0.0012646710040632755
    Epoch: 6000   Error: 0.0008910514800247452
    Epoch: 7000   Error: 0.0006602873040322224
    Epoch: 8000   Error: 0.0005081961006147329
    Epoch: 9000   Error: 0.0004028528701046857
    Epoch: 9999   Error: 0.0003270377487769315
    Epoch: 10000   Error: 0.0003269728572615501

Valid options are: `or`, `and`, `xor`, `nand`

Run tests

    $ mix test
    
###Huge props

* Levi Thompson [https://github.com/levithomason](https://github.com/levithomason)
* Dev Coop group for support [http://www.meetup.com/dev-coop/](http://www.meetup.com/dev-coop/)


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add neural_network to your list of dependencies in `mix.exs`:

        def deps do
          [{:neural_network, "~> 0.0.1"}]
        end

  2. Ensure neural_network is started before your application:

        def application do
          [applications: [:neural_network]]
        end


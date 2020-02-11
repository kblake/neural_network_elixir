# Neural Network

A neural network made up of layers of neurons connected to each other to form a relationship allowing it to learn.

After cloning:

    $ mix deps.get
    $ mix compile

## Usage

Run the trainer and see the network learn using OR GATE data

    $ mix learn or

You should see output like this:

    OR gate learning *********************************************
    Epoch: 0   Error: 0.0978034950879825143
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
    **************************************************************

Run the trainer and see the network learn using IRIS FLOWER GATE data

    $ mix learn iris_flower

You should see output like this:

    IRIS_FLOWER gate learning *********************************************
    Epoch: 0   Error: 0.0164425788515711185
    Epoch: 1000   Error: 0.027344153205250403
    Epoch: 2000   Error: 0.0265533867778006451
    Epoch: 3000   Error: 0.0266624718167679346
    Epoch: 4000   Error: 0.0268164947904966262
    Epoch: 5000   Error: 0.026857493502782933
    Epoch: 6000   Error: 0.026794287038049043
    Epoch: 7000   Error: 0.0266556275054049274
    Epoch: 8000   Error: 0.0264642981722699525
    Epoch: 9000   Error: 0.0262360305030914023
    Epoch: 9999   Error: 0.025981881761432242
    Epoch: 10000   Error: 0.025981617016649871
    **************************************************************


Valid options are: `or`, `and`, `xor`, `nand`, `iris_flower`


Run tests

    $ mix test


### Run Console
    alias NeuralNetwork.{DataFactory, Network, LossFunction, Layer}
    {:ok, network_pid} = Network.start_link([2, 1], %{activation: :relu})
    data = DataFactory.gate_for("or")
    Network.fit(network_pid, data, %{epochs: 10_000, log_freqs: 1000})
    Network.predict(network_pid, [1,1])


### Huge props

* Levi Thompson [https://github.com/levithomason](https://github.com/levithomason)
* Dev Coop group for support [http://www.meetup.com/dev-coop/](http://www.meetup.com/dev-coop/)


## Installation

[Available in Hex](https://hex.pm/packages/neural_network), the package can be installed as:

  1. Add neural_network to your list of dependencies in `mix.exs`:

        def deps do
          [{:neural_network, "~> 0.1.4"}]
        end

  2. Ensure neural_network is started before your application:

        def application do
          [applications: [:neural_network]]
        end

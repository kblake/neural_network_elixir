defmodule NeuralNetwork.NetworkTest do
  use ExUnit.Case
  doctest NeuralNetwork.Network

  alias NeuralNetwork.{Network}

  test "Create network: input layer initialized" do
    network = Network.start_link([3,2,5])
    assert length(network.input_layer.neurons) == 3 + 1 # account for bias neuron being added
  end

  test "create output layer" do
    network = Network.start_link([3,2,5])
    assert length(network.output_layer.neurons) == 5
  end

  test "create hidden layer(s)" do
    network = Network.start_link([3,2,6,5])
    assert length(List.first(network.hidden_layers).neurons) == 2 + 1 # bias added
    assert length(List.last(network.hidden_layers).neurons) == 6 + 1 # bias added
  end

  test "update layers" do
    networkA = Network.start_link([3,2,5])
    networkB = Network.start_link([1,3,2])

    layers = %{
      input_layer: networkB.input_layer,
      output_layer: networkB.output_layer,
      hidden_layers: networkB.hidden_layers
    }
    networkA = Network.update(networkA.pid, layers)

    assert length(networkA.input_layer.neurons) == 2 # bias added
    assert length(networkA.output_layer.neurons) == 2
    assert length(List.first(networkA.hidden_layers).neurons) == 3 + 1 # bias added
  end
end

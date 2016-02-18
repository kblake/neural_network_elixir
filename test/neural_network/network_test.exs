defmodule NeuralNetwork.NetworkTest do
  use ExUnit.Case
  doctest NeuralNetwork.Network

  alias NeuralNetwork.{Layer, Network}

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
end

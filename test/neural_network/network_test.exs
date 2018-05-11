defmodule NeuralNetwork.NetworkTest do
  use ExUnit.Case
  doctest NeuralNetwork.Network

  alias NeuralNetwork.{Layer, Network}

  test "keep track of error with default" do
    {:ok, pid} = Network.start_link()
    assert Network.get(pid).error == 0
  end

  test "Create network: input layer initialized" do
    {:ok, pid} = Network.start_link([3, 2, 5])
    # account for bias neuron being added
    assert length((Network.get(pid).input_layer |> Layer.get()).neurons) == 3 + 1
  end

  test "create output layer" do
    {:ok, pid} = Network.start_link([3, 2, 5])
    assert length((Network.get(pid).output_layer |> Layer.get()).neurons) == 5
  end

  test "create hidden layer(s)" do
    {:ok, pid} = Network.start_link([3, 2, 6, 5])
    hidden_neurons_one = (Network.get(pid).hidden_layers |> List.first() |> Layer.get()).neurons
    hidden_neurons_two = (Network.get(pid).hidden_layers |> List.last() |> Layer.get()).neurons
    # bias added
    assert length(hidden_neurons_one) == 2 + 1
    # bias added
    assert length(hidden_neurons_two) == 6 + 1
  end

  test "update layers" do
    {:ok, pidA} = Network.start_link([3, 2, 5])
    {:ok, pidB} = Network.start_link([1, 3, 2])

    layers = %{
      input_layer: Network.get(pidB).input_layer,
      output_layer: Network.get(pidB).output_layer,
      hidden_layers: Network.get(pidB).hidden_layers
    }

    Network.update(pidA, layers)

    assert length((Network.get(pidA).input_layer |> Layer.get()).neurons) == 2
    assert length((Network.get(pidA).output_layer |> Layer.get()).neurons) == 2
    hidden_neurons_one = (Network.get(pidA).hidden_layers |> List.first() |> Layer.get()).neurons
    assert length(hidden_neurons_one) == 4
  end
end

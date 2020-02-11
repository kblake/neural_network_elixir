defmodule NeuralNetwork.NetworkTest do
  use ExUnit.Case
  doctest NeuralNetwork.Network

  alias NeuralNetwork.{Layer, Network, DataFactory}

  test "keep track of error with default" do
    {:ok, pid} = Network.start_link()
    assert Network.model(pid).error == 0
  end

  test "Create network: input layer initialized" do
    {:ok, pid} = Network.start_link([3, 2, 5], %{activation: :relu})
    # account for bias neuron being added
    assert length((Network.model(pid).input_layer |> Layer.get()).neurons) == 3 + 1
  end

  test "create output layer" do
    {:ok, pid} = Network.start_link([3, 2, 5], %{activation: :relu})
    assert length((Network.model(pid).output_layer |> Layer.get()).neurons) == 5
  end

  test "create hidden layer(s)" do
    {:ok, pid} = Network.start_link([3, 2, 6, 5], %{activation: :relu})
    hidden_neurons_one = (Network.model(pid).hidden_layers |> List.first() |> Layer.get()).neurons
    hidden_neurons_two = (Network.model(pid).hidden_layers |> List.last() |> Layer.get()).neurons
    # bias added
    assert length(hidden_neurons_one) == 2 + 1
    # bias added
    assert length(hidden_neurons_two) == 6 + 1
  end

  test "update layers" do
    {:ok, pid_a} = Network.start_link([3, 2, 5], %{activation: :relu})
    {:ok, pid_b} = Network.start_link([1, 3, 2], %{activation: :relu})

    layers = %{
      input_layer: Network.model(pid_b).input_layer,
      output_layer: Network.model(pid_b).output_layer,
      hidden_layers: Network.model(pid_b).hidden_layers
    }

    Network.update(pid_a, layers)

    assert length((Network.model(pid_a).input_layer |> Layer.get()).neurons) == 2
    assert length((Network.model(pid_a).output_layer |> Layer.get()).neurons) == 2
    hidden_neurons_one = (Network.model(pid_a).hidden_layers |> List.first() |> Layer.get()).neurons
    assert length(hidden_neurons_one) == 4
  end

  test "Predict return for gate AND" do
    {:ok, pid} = Network.start_link([2, 1], %{activation: :relu})

    data = DataFactory.gate_for("and")

    pid
    |> Network.fit(data, %{epochs: 10_000, log_freqs: 1000})

    assert List.first(Network.predict(pid, [0,0])) < 0.09
    assert List.first(Network.predict(pid, [0,1])) < 0.09
    assert List.first(Network.predict(pid, [1,0])) < 0.09
    assert List.first(Network.predict(pid, [1,1])) > 0.99
  end
end

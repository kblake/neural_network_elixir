defmodule NeuralNetwork.ConnectionTest do
  use ExUnit.Case
  doctest NeuralNetwork.Connection

  test "has default values" do
    connection = %NeuralNetwork.Connection{}
    assert connection.source == %{}
    assert connection.target == %{}
    assert connection.weight == 0.4
  end

  test "has default values using an agent" do
    NeuralNetwork.Connection.start_link(:one)
    connection = NeuralNetwork.Connection.get(:one)
    assert connection.source == %{}
    assert connection.target == %{}
    assert connection.weight == 0.4
    NeuralNetwork.Connection.stop(:one)
  end

  test "update connection values" do
    NeuralNetwork.Connection.start_link(:one)

    NeuralNetwork.Connection.update(:one, :source, %NeuralNetwork.Neuron{input: 10})
    connection = NeuralNetwork.Connection.get(:one)
    assert is_map(connection.source)
    assert connection.source.input == 10

    NeuralNetwork.Connection.update(:one, :target, %NeuralNetwork.Neuron{input: 5})
    connection = NeuralNetwork.Connection.get(:one)
    assert is_map(connection.target)
    assert connection.target.input == 5

    NeuralNetwork.Connection.stop(:one)
  end

  test "create a connection for two neurons" do
    NeuralNetwork.Neuron.start_link(:neuronA)
    neuronA = NeuralNetwork.Neuron.start_link(:neuronA)
    NeuralNetwork.Neuron.start_link(:neuronB)
    neuronB = NeuralNetwork.Neuron.start_link(:neuronB)

    {:ok, connection} = NeuralNetwork.Connection.connection_for(neuronA, neuronB)

    assert connection.source == neuronA
    assert connection.target == neuronB
  end
end

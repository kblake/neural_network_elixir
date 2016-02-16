defmodule NeuralNetwork.ConnectionTest do
  use ExUnit.Case
  doctest NeuralNetwork.Connection

  alias NeuralNetwork.{Neuron, Connection}

  test "has default values using an agent" do
    connection = Connection.start_link
    assert connection.source_pid == nil
    assert connection.target_pid == nil
    assert connection.weight     == 0.4
  end

  test "create new connection with custom values" do
    neuronA = Neuron.start_link
    neuronB = Neuron.start_link
    connection = Connection.start_link(%{source_pid: neuronA.pid, target_pid: neuronB.pid})

    assert connection.source_pid == neuronA.pid
    assert connection.target_pid == neuronB.pid
    assert connection.weight     == 0.4
  end

  test "update connection values" do
    connection = Connection.start_link
    neuronA = Neuron.start_link(%{input: 10})
    neuronB = Neuron.start_link(%{input: 5})
    connection = Connection.update(connection.pid, %{source_pid: neuronA.pid, target_pid: neuronB.pid})
    assert Neuron.get(connection.source_pid).input == 10
    assert Neuron.get(connection.target_pid).input == 5
  end

  test "create a connection for two neurons" do
    neuronA = Neuron.start_link
    neuronB = Neuron.start_link

    connection = Connection.connection_for(neuronA, neuronB)

    assert connection.source_pid == neuronA.pid
    assert connection.target_pid == neuronB.pid
  end
end

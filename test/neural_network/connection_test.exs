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
    pidA = Neuron.start_link
    pidB = Neuron.start_link
    connection = Connection.start_link(%{source_pid: pidA, target_pid: pidB})

    assert connection.source_pid == pidA
    assert connection.target_pid == pidB
    assert connection.weight     == 0.4
  end

  test "update connection values" do
    connection = Connection.start_link
    pidA = Neuron.start_link(%{input: 10})
    pidB = Neuron.start_link(%{input: 5})
    connection = Connection.update(connection.pid, %{source_pid: pidA, target_pid: pidB})
    assert Neuron.get(connection.source_pid).input == 10
    assert Neuron.get(connection.target_pid).input == 5
  end

  test "create a connection for two neurons" do
    pidA = Neuron.start_link
    pidB = Neuron.start_link

    connection = Connection.connection_for(pidA, pidB)

    assert connection.source_pid == pidA
    assert connection.target_pid == pidB
  end
end

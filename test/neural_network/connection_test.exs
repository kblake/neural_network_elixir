defmodule NeuralNetwork.ConnectionTest do
  use ExUnit.Case
  doctest NeuralNetwork.Connection

  alias NeuralNetwork.{Neuron, Connection}

  test "has default values" do
    connection = %Connection{}
    assert connection.name        == ""
    assert connection.source_name == nil
    assert connection.target_name == nil
    assert connection.weight      == 0.4
  end

  test "has default values using an agent" do
    Connection.start_link(%{name: :one})
    connection = Connection.get(:one)
    assert connection.name        == :one
    assert connection.source_name == nil
    assert connection.target_name == nil
    assert connection.weight      == 0.4
  end

  test "create new connection with custom values" do
    Neuron.start_link(%{name: :a})
    Neuron.start_link(%{name: :b})
    Connection.start_link(%{name: :one, source_name: Neuron.get(:a).name, target_name: Neuron.get(:b).name})
    connection = Connection.get(:one)

    IO.inspect connection
    assert connection.source_name == Neuron.get(:a).name
    assert connection.target_name == Neuron.get(:b).name
    assert connection.weight      == 0.4
  end

  test "update connection values" do
    Connection.start_link(%{name: :one})
    Neuron.start_link(%{name: :a, input: 10})
    Neuron.start_link(%{name: :b, input: 5})
    Connection.update(:one, %{source_name: Neuron.get(:a).name, target_name: Neuron.get(:b).name})
    connection = Connection.get(:one)
    assert Neuron.get(connection.source_name).input == 10
    assert Neuron.get(connection.target_name).input == 5
  end

  test "create a connection for two neurons" do
    Neuron.start_link(%{name: :neuronA})
    neuronA = Neuron.get(:neuronA)
    Neuron.start_link(%{name: :neuronB})
    neuronB = Neuron.get(:neuronB)

    connection = Connection.connection_for(neuronA, neuronB)

    assert connection.source_name == neuronA.name
    assert connection.target_name == neuronB.name
  end
end

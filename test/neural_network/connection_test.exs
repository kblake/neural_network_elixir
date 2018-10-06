defmodule NeuralNetwork.ConnectionTest do
  use ExUnit.Case
  doctest NeuralNetwork.Connection

  alias NeuralNetwork.{Connection, Neuron}

  test "has default values using an agent" do
    {:ok, pid} = Connection.start_link()
    connection = Connection.get(pid)
    assert connection.source_pid == nil
    assert connection.target_pid == nil
    assert connection.weight == 0.4
  end

  test "create new connection with custom values" do
    {:ok, pid_a} = Neuron.start_link()
    {:ok, pid_b} = Neuron.start_link()
    {:ok, connection_pid} = Connection.start_link(%{source_pid: pid_a, target_pid: pid_b})
    connection = Connection.get(connection_pid)

    assert connection.source_pid == pid_a
    assert connection.target_pid == pid_b
    assert connection.weight == 0.4
  end

  test "update connection values" do
    {:ok, connection_pid} = Connection.start_link()
    {:ok, pid_a} = Neuron.start_link(%{input: 10})
    {:ok, pid_b} = Neuron.start_link(%{input: 5})
    Connection.update(connection_pid, %{source_pid: pid_a, target_pid: pid_b})

    connection = Connection.get(connection_pid)
    assert Neuron.get(connection.source_pid).input == 10
    assert Neuron.get(connection.target_pid).input == 5
  end

  test "create a connection for two neurons" do
    {:ok, pid_a} = Neuron.start_link()
    {:ok, pid_b} = Neuron.start_link()

    {:ok, connection_pid} = Connection.connection_for(pid_a, pid_b)
    connection = Connection.get(connection_pid)

    assert connection.source_pid == pid_a
    assert connection.target_pid == pid_b
  end
end

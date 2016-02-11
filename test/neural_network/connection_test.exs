defmodule NeuralNetwork.ConnectionTest do
  use ExUnit.Case, async: true
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
  end
end

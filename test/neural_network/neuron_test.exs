defmodule NeuralNetwork.NeuronTest do
  use ExUnit.Case, async: true
  doctest NeuralNetwork.Neuron

  test "has default values" do
    neuron = %NeuralNetwork.Neuron{}
    assert neuron.input     == 0
    assert neuron.output    == 0
    assert neuron.incoming  == []
    assert neuron.outgoing  == []
    assert neuron.bias?     == false
  end

  test "has default values as an agent" do
    NeuralNetwork.Neuron.start_link(:one)
    neuron = NeuralNetwork.Neuron.get(:one)
    assert neuron.input     == 0
    assert neuron.output    == 0
    assert neuron.incoming  == []
    assert neuron.outgoing  == []
    assert neuron.bias?     == false
  end

  test "has learning rate" do
    assert NeuralNetwork.Neuron.learning_rate == 0.3
  end

  test ".connect" do
    # neuronA = %NeuralNetwork.Neuron{ outgoing: [%NeuralNetwork.Connection{}] }
    # neuronB = %NeuralNetwork.Neuron{ incoming: [%NeuralNetwork.Connection{}] }

    # {:ok, neuronA, neuronB} = NeuralNetwork.Neuron.connect(neuronA, neuronB)

    # assert length(neuronA.outgoing) == 2
    # assert length(neuronB.incoming) == 2
  end
end

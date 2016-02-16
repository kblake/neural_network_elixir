defmodule NeuralNetwork.LayerTest do
  use ExUnit.Case
  doctest NeuralNetwork.Layer

  alias NeuralNetwork.{Layer}

  test "has default values using an agent" do
    layer = Layer.start_link
    assert layer.neurons == []
  end

  test "create new layer with neuron size" do
    layer = Layer.start_link(%{neuron_size: 3})
    assert length(layer.neurons) == 3
    assert is_map(List.first(layer.neurons))
  end

  test "create new layer with empty neuron list when size is negative" do
    layer = Layer.start_link(%{neuron_size: -3})
    assert length(layer.neurons) == 0
  end
end

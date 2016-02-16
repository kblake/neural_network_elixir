defmodule NeuralNetwork.LayerTest do
  use ExUnit.Case
  doctest NeuralNetwork.Layer

  alias NeuralNetwork.{Neuron, Layer}

  test "has default values using an agent" do
    layer = Layer.start_link
    assert layer.neurons == []
  end

  test "create new layer with custom values" do
    layer = Layer.start_link(%{neurons: ["foo"]})
    assert layer.neurons == ["foo"]
  end

  test "update layer values" do
    layer = Layer.start_link
    layer = Layer.update(layer.pid, %{neurons: ["bar"]})
    assert layer.neurons == ["bar"]
  end
end

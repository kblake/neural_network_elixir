defmodule NeuralNetwork.LayerTest do
  use ExUnit.Case
  doctest NeuralNetwork.Layer

  alias NeuralNetwork.{Neuron, Layer}

  test "has default values using an agent" do
    Layer.start_link(%{name: :one})
    layer = Layer.get(:one)
    assert layer.name    == :one
    assert layer.neurons == []
  end

  test "create new layer with custom values" do
    Layer.start_link(%{name: :one, neurons: ["foo"]})
    layer = Layer.get(:one)

    assert layer.neurons == ["foo"]
  end

  test "update layer values" do
    Layer.start_link(%{name: :one})
    Layer.update(:one, %{neurons: ["bar"]})
    layer = Layer.get(:one)
    assert Layer.get(:one).neurons == ["bar"]
  end
end

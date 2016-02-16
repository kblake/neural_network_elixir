defmodule NeuralNetwork.LayerTest do
  use ExUnit.Case
  doctest NeuralNetwork.Layer

  alias NeuralNetwork.{Neuron, Layer}

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

  test "connect layers: no outgoing or incoming neurons connected" do
    input_layer  = Layer.start_link(%{neuron_size: 2})
    output_layer = Layer.start_link(%{neuron_size: 2})

    for neuron <- input_layer.neurons do
      assert length(neuron.outgoing) == 0
      assert length(neuron.incoming) == 0
    end

    for neuron <- output_layer.neurons do
      assert length(neuron.outgoing) == 0
      assert length(neuron.incoming) == 0
    end
  end

  test "connect layers: input layer's outgoing neurons are stored" do
    input_layer  = Layer.start_link(%{neuron_size: 2})
    output_layer = Layer.start_link(%{neuron_size: 2})
    {:ok, input_layer, output_layer} = Layer.connect(input_layer, output_layer)


    for neuron <- input_layer.neurons do
      assert length(neuron.outgoing) == 2
      assert length(neuron.incoming) == 0
      assert Enum.map(neuron.outgoing, fn connection -> Neuron.get(connection.target_pid) end) == output_layer.neurons
    end
  end

  test "connect layers: output layer's incoming neurons + bias neuron are stored" do
    input_layer  = Layer.start_link(%{neuron_size: 2})
    output_layer = Layer.start_link(%{neuron_size: 2})
    {:ok, input_layer, output_layer} = Layer.connect(input_layer, output_layer)

    for neuron <- output_layer.neurons do
      assert length(neuron.incoming) == 3
      source_neurons = Enum.map neuron.incoming, fn(connection) -> Neuron.get(connection.source_pid) end
      assert Enum.any?(source_neurons, fn(source_neuron) -> source_neuron.bias? end)
      assert length(neuron.outgoing) == 0
      assert Enum.map(neuron.incoming, fn connection -> Neuron.get(connection.source_pid) end) == input_layer.neurons
    end
  end

  test "activate a layer: when values are nil" do
    layer  = Layer.start_link(%{neuron_size: 2})
    layer = Layer.activate(layer)

    for neuron <- layer.neurons do
      assert neuron.output == 0.5
    end
  end

  test "activate a layer: with values" do
    layer  = Layer.start_link(%{neuron_size: 2})
    layer = Layer.activate(layer, [1,2])

    for neuron <- layer.neurons do
      assert neuron.output >= 0.5 && neuron.output <= 1.0
    end
  end
end

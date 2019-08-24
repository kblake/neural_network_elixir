defmodule NeuralNetwork.LayerTest do
  use ExUnit.Case
  doctest NeuralNetwork.Layer

  alias NeuralNetwork.{Connection, Layer, Neuron}

  test "has default values using an agent" do
    {:ok, pid} = Layer.start_link()
    assert Layer.get(pid).neurons == []
  end

  test "create new layer with neuron size" do
    {:ok, pid} = Layer.start_link(%{neuron_size: 3})
    layer = Layer.get(pid)
    assert length(layer.neurons) == 3
    assert is_pid(List.first(layer.neurons))
  end

  test "create new layer with empty neuron list when size is negative" do
    {:ok, pid} = Layer.start_link(%{neuron_size: -3})
    layer = Layer.get(pid)
    assert layer.neurons |> Enum.empty?()
  end

  test "connect layers: no outgoing or incoming neurons connected" do
    {:ok, input_layer_pid} = Layer.start_link(%{neuron_size: 2})
    {:ok, output_layer_pid} = Layer.start_link(%{neuron_size: 2})

    for neuron <- Layer.get(input_layer_pid).neurons do
      assert Neuron.get(neuron).outgoing |> Enum.empty?()
      assert Neuron.get(neuron).incoming |> Enum.empty?()
    end

    for neuron <- Layer.get(output_layer_pid).neurons do
      assert Neuron.get(neuron).outgoing |> Enum.empty?()
      assert Neuron.get(neuron).incoming |> Enum.empty?()
    end
  end

  test "connect layers: input layer's outgoing neurons are stored" do
    {:ok, input_layer_pid} = Layer.start_link(%{neuron_size: 2})
    {:ok, output_layer_pid} = Layer.start_link(%{neuron_size: 2})
    Layer.connect(input_layer_pid, output_layer_pid)

    for neuron <- Layer.get(input_layer_pid).neurons do
      assert length(Neuron.get(neuron).outgoing) == 2
      assert Neuron.get(neuron).incoming |> Enum.empty?()

      connection_target_ids =
        Enum.map(Neuron.get(neuron).outgoing, fn connection_pid ->
          Connection.get(connection_pid).target_pid
        end)

      assert connection_target_ids == Layer.get(output_layer_pid).neurons
    end
  end

  test "connect layers: output layer's incoming neurons + bias neuron are stored" do
    {:ok, input_layer_pid} = Layer.start_link(%{neuron_size: 2})
    {:ok, output_layer_pid} = Layer.start_link(%{neuron_size: 2})
    Layer.connect(input_layer_pid, output_layer_pid)

    for neuron <- Layer.get(output_layer_pid).neurons do
      assert length(Neuron.get(neuron).incoming) == 3

      source_neurons =
        Enum.map(Neuron.get(neuron).incoming, fn connection_pid ->
          Neuron.get(Connection.get(connection_pid).source_pid)
        end)

      assert Enum.any?(source_neurons, fn source_neuron -> source_neuron.bias? end)
      assert Neuron.get(neuron).outgoing |> Enum.empty?()

      assert Enum.map(Neuron.get(neuron).incoming, fn connection_pid ->
               Connection.get(connection_pid).source_pid
             end) == Layer.get(input_layer_pid).neurons
    end
  end

  test "activate a layer: when values are nil" do
    {:ok, pid} = Layer.start_link(%{neuron_size: 2})
    Layer.activate(pid)

    for neuron <- Layer.get(pid).neurons do
      assert Neuron.get(neuron).output == 0.5
    end
  end

  test "activate a layer: with values" do
    {:ok, pid} = Layer.start_link(%{neuron_size: 2})
    pid |> Layer.activate([1, 2])

    for neuron_pid <- Layer.get(pid).neurons do
      neuron = Neuron.get(neuron_pid)
      assert neuron.output >= 0.5 && neuron.output <= 1.0
    end
  end
end

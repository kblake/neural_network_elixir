defmodule NeuralNetwork.Network do
  alias NeuralNetwork.{Neuron, Layer, Network}

  defstruct pid: nil, input_layer: %{}, output_layer: %{}, hidden_layers: [], error: 0

  def start_link(layer_sizes \\ []) do
    {:ok, pid} = Agent.start_link(fn -> %Network{} end)

    layers = map_layers(
      input_neurons(layer_sizes),
      hidden_neurons(layer_sizes),
      output_neurons(layer_sizes))

    pid |> update(layers)
    pid |> connect_layers
    pid
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def update(pid, fields) do
    fields = Map.merge(fields, %{pid: pid}) # preserve the pid!!
    Agent.update(pid, fn network -> Map.merge(network, fields) end)
  end

  defp input_neurons(layer_sizes) do
    size = layer_sizes |> List.first
    Layer.start_link(%{neuron_size: size})
  end

  defp output_neurons(layer_sizes) do
    size = layer_sizes |> List.last
    Layer.start_link(%{neuron_size: size})
  end

  defp hidden_neurons(layer_sizes) do
    layer_sizes
    |> hidden_layer_slice
    |> Enum.map(fn size ->
         Layer.start_link(%{neuron_size: size})
       end)
  end

  defp hidden_layer_slice(layer_sizes) do
    layer_sizes
    |> Enum.slice(1..length(layer_sizes) - 2)
  end

  defp connect_layers(pid) do
    layers = Network.get(pid) |> flatten_layers

    layers
    |> Stream.with_index
    |> Enum.each(fn(tuple) ->
      {layer, index} = tuple
      next_index = index + 1

      if Enum.at(layers, next_index) do
        Layer.connect(layer, Enum.at(layers, next_index))
      end
    end)
  end

  defp flatten_layers(network) do
    [network.input_layer] ++ network.hidden_layers ++ [network.output_layer]
  end

  def activate(network, input_values) do
    network.input_layer |> Layer.activate(input_values)

    Enum.map(network.hidden_layers, fn hidden_layer ->
      hidden_layer |> Layer.activate
    end)

    network.output_layer |> Layer.activate
  end

  # Back Propogate:
  # train layers in reverse
  def train(network, target_outputs) do
    Layer.get(network.output_layer) |> Layer.train(target_outputs)
    network.pid |> update(%{error: error_function(network, target_outputs)})

    network.hidden_layers
    |> Enum.reverse
    |> Enum.each(fn layer -> layer |> Layer.train end)


    input_layer = Layer.get(network.input_layer) |> Layer.train(target_outputs)
  end

  defp error_function(network, target_outputs) do
    (Layer.get(network.output_layer).neurons
    |> Stream.with_index
    |> Enum.reduce(0, fn({neuron, index}, sum) ->
         sum + 0.5 * :math.pow(Enum.at(target_outputs, index) - Neuron.get(neuron).output, 2)
       end)) / length(Layer.get(network.output_layer).neurons)
  end

  defp map_layers(input_layer, hidden_layers, output_layer) do
    %{
      input_layer:    input_layer,
      output_layer:   output_layer,
      hidden_layers:  hidden_layers
    }
  end
end

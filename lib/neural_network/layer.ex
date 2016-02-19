defmodule NeuralNetwork.Layer do
  alias NeuralNetwork.{Neuron, Layer}

  defstruct pid: "", neurons: []

  def start_link(layer_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %Layer{} end)
    neurons = create_neurons(Map.get(layer_fields, :neuron_size))
    update(pid, %{pid: pid, neurons: neurons})
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def update(pid, fields) do
    Agent.update(pid, fn layer -> Map.merge(layer, fields) end)
    get(pid)
  end

  defp create_neurons(nil), do: []
  defp create_neurons(size) when size < 1, do: []

  defp create_neurons(size) when size > 0 do
    Enum.into 1..size, [], fn _ -> Neuron.start_link end
  end

  def add_neurons(layer, neurons) do
    update(layer.pid, %{neurons: get(layer.pid).neurons ++ neurons})
    get(layer.pid)
  end

  def clear_neurons(layer) do
    update(layer.pid, %{neurons: []})
  end

  def set_neurons(layer, neurons) do
    layer
    |> clear_neurons
    |> add_neurons(neurons)
  end

  def train(layer, target_outputs \\ []) do
    trained_neurons = layer.neurons
    |> Stream.with_index
    |> Enum.map(fn(tuple) ->
      {neuron, index} = tuple
      neuron |> Neuron.train(Enum.at(target_outputs, index))
    end)

    layer |> set_neurons(trained_neurons)
  end

  def connect(input_layer, output_layer) do
    unless contains_bias?(input_layer) do
      input_layer |> add_neurons([Neuron.start_link(%{bias?: true})])
    end

    for source_neuron <- get(input_layer.pid).neurons, target_neuron <- get(output_layer.pid).neurons do
      Neuron.connect(source_neuron, target_neuron)
    end

    updated_source_neurons = Enum.map(get(input_layer.pid).neurons, fn neuron -> Neuron.get(neuron.pid) end)
    input_layer |> set_neurons(updated_source_neurons)
    updated_output_neurons = Enum.map(get(output_layer.pid).neurons, fn neuron -> Neuron.get(neuron.pid) end)
    output_layer |> set_neurons(updated_output_neurons)

    {:ok, get(input_layer.pid), get(output_layer.pid)}
  end

  defp contains_bias?(layer) do
    Enum.any? layer.neurons, fn(neuron) -> neuron.bias? end
  end

  def activate(layer, values \\ nil) do
    values = List.wrap(values) # coerce to [] if nil

    activated_neurons = layer.neurons
    |> Stream.with_index
    |> Enum.map(fn(tuple) ->
         {neuron, index} = tuple
         neuron |> Neuron.activate(Enum.at(values, index))
       end)

    layer |> set_neurons(activated_neurons)
  end

  def neuron_outputs(layer) do
    layer.neurons |> Enum.map(fn neuron -> neuron.output end)
  end
end

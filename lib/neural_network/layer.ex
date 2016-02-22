defmodule NeuralNetwork.Layer do
  alias NeuralNetwork.{Neuron, Layer}

  defstruct pid: "", neurons: []

  def start_link(layer_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %Layer{} end)
    neurons = create_neurons(Map.get(layer_fields, :neuron_size))
    pid |> update(%{pid: pid, neurons: neurons})

    {:ok, pid}
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def update(pid, fields) do
    Agent.update(pid, fn layer -> Map.merge(layer, fields) end)
  end

  defp create_neurons(nil), do: []
  defp create_neurons(size) when size < 1, do: []
  defp create_neurons(size) when size > 0 do
    Enum.into 1..size, [], fn _ -> {:ok, pid} = Neuron.start_link; pid end
  end

  def add_neurons(layer_pid, neurons) do
    layer_pid |> update(%{neurons: get(layer_pid).neurons ++ neurons})
  end

  def clear_neurons(layer_pid) do
    layer_pid |> update(%{neurons: []})
  end

  def set_neurons(layer_pid, neurons) do
    layer_pid
    |> clear_neurons
    |> add_neurons(neurons)
  end

  def train(layer, target_outputs \\ []) do
    trained_neurons = layer.neurons
    |> Stream.with_index
    |> Enum.each(fn(tuple) ->
      {neuron, index} = tuple
      neuron |> Neuron.train(Enum.at(target_outputs, index))
    end)
  end

  def connect(input_layer_pid, output_layer_pid) do
    input_layer  = get(input_layer_pid)
    output_layer = get(output_layer_pid)

    unless contains_bias?(input_layer) do
      {:ok, pid} = Neuron.start_link(%{bias?: true})
      input_layer_pid |> add_neurons([pid])
    end

    for source_neuron <- get(input_layer_pid).neurons, target_neuron <- get(output_layer_pid).neurons do
      Neuron.connect(source_neuron, target_neuron)
    end
  end

  defp contains_bias?(layer) do
    Enum.any? layer.neurons, fn(neuron) -> Neuron.get(neuron).bias? end
  end

  def activate(layer_pid, values \\ nil) do
    layer  = get(layer_pid)
    values = List.wrap(values) # coerce to [] if nil

    activated_neurons = layer.neurons
    |> Stream.with_index
    |> Enum.each(fn(tuple) ->
         {neuron, index} = tuple
         neuron |> Neuron.activate(Enum.at(values, index))
       end)
  end
end

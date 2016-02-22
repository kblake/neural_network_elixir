defmodule NeuralNetwork.Layer do
  @moduledoc """
  List of neurons. The are used to apply behaviors on sets of neurons.
  A network is made up layers (which are made up of neurons).
  """

  alias NeuralNetwork.{Neuron, Layer}

  defstruct pid: "", neurons: []

  def start_link(layer_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %Layer{} end)
    neurons = create_neurons(Map.get(layer_fields, :neuron_size))
    pid |> update(%{pid: pid, neurons: neurons})

    {:ok, pid}
  end

  @doc """
  Return a layer by pid.
  """
  def get(pid), do: Agent.get(pid, &(&1))

  @doc """
  Update a layer by passing in a pid and a map of fields to update.
  """
  def update(pid, fields) do
    Agent.update(pid, fn layer -> Map.merge(layer, fields) end)
  end

  defp create_neurons(nil), do: []
  defp create_neurons(size) when size < 1, do: []
  defp create_neurons(size) when size > 0 do
    Enum.into 1..size, [], fn _ -> {:ok, pid} = Neuron.start_link; pid end
  end

  @doc """
  Add neurons to the layer.
  """
  def add_neurons(layer_pid, neurons) do
    layer_pid |> update(%{neurons: get(layer_pid).neurons ++ neurons})
  end

  @doc """
  Empty out the layer of all neurons.
  """
  def clear_neurons(layer_pid) do
    layer_pid |> update(%{neurons: []})
  end

  @doc """
  Clear and set neurons in the layer with a given list of neurons.
  """
  def set_neurons(layer_pid, neurons) do
    layer_pid
    |> clear_neurons
    |> add_neurons(neurons)
  end

  @doc """
  Update all deltas for each neuron.
  """
  def train(layer, target_outputs \\ []) do
    layer.neurons
    |> Stream.with_index
    |> Enum.each(fn(tuple) ->
      {neuron, index} = tuple
      neuron |> Neuron.train(Enum.at(target_outputs, index))
    end)
  end

  @doc """
  Connect every neuron in the input layer to every neuron in the target layer.
  """
  def connect(input_layer_pid, output_layer_pid) do
    input_layer  = get(input_layer_pid)

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

  @doc """
  Activate all neurons in the layer with a list of values.
  """
  def activate(layer_pid, values \\ nil) do
    layer  = get(layer_pid)
    values = List.wrap(values) # coerce to [] if nil

    layer.neurons
    |> Stream.with_index
    |> Enum.each(fn(tuple) ->
         {neuron, index} = tuple
         neuron |> Neuron.activate(Enum.at(values, index))
       end)
  end
end

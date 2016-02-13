defmodule NeuralNetwork.Neuron do
  defstruct name: "", input: 0, output: 0, incoming: [], outgoing: [], bias?: false

  @learning_rate 0.3

  def learning_rate do
    @learning_rate
  end

  def start_link(name_field) do
    Agent.start_link(fn -> Map.merge(%NeuralNetwork.Neuron{}, name_field) end, name: name_field.name)
  end

  def start_link(neuron_fields) do
    Agent.start_link(fn -> Map.merge(%NeuralNetwork.Neuron{}, neuron_fields) end, name: neuron_fields.name)
  end

  def update(name, neuron_fields) do
    Agent.update(name, fn neuron -> Map.merge(neuron, neuron_fields) end)
  end

  def get(name) do
    Agent.get(name, &(&1))
  end

  def connect(source, target) do
    connection = NeuralNetwork.Connection.connection_for(source, target)
    NeuralNetwork.Neuron.update(source.name, %{outgoing: source.outgoing ++ [connection]})
    NeuralNetwork.Neuron.update(target.name, %{incoming: target.incoming ++ [connection]})
    {:ok, NeuralNetwork.Neuron.get(source.name), NeuralNetwork.Neuron.get(target.name)}
  end
end

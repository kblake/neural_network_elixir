defmodule NeuralNetwork.Neuron do
  defstruct input: 0, output: 0, incoming: [], outgoing: [], bias?: false

  @learning_rate 0.3

  def learning_rate do
    @learning_rate
  end

  def start_link(name) do
    Agent.start_link(fn -> %NeuralNetwork.Neuron{} end, name: name)
  end

  def start_link(name, neuron_fields) do
    Agent.start_link(fn -> Map.merge(%NeuralNetwork.Neuron{}, neuron_fields) end, name: name)
  end

  def update(name, neuron_fields) do
    Agent.update(name, fn neuron -> Map.merge(neuron, neuron_fields) end)
  end

  def get(name) do
    Agent.get(name, &(&1))
  end
end

defmodule NeuralNetwork.Layer do
  alias NeuralNetwork.{Neuron, Connection}

  defstruct name: "", neurons: []

  def start_link(layer_fields) do
    Agent.start_link(fn ->
      Map.merge(%NeuralNetwork.Layer{}, layer_fields)
    end, name: layer_fields.name)
  end

  def get(name), do: Agent.get(name, &(&1))

  def update(name, fields) do
    Agent.update(name, fn layer -> Map.merge(layer, fields) end)
  end
end

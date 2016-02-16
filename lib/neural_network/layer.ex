defmodule NeuralNetwork.Layer do
  alias NeuralNetwork.{Layer}

  defstruct pid: "", neurons: []

  def start_link(layer_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %NeuralNetwork.Layer{} end)
    update(pid, Map.merge(layer_fields, %{pid: pid}))
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def update(pid, fields) do
    Agent.update(pid, fn layer -> Map.merge(layer, fields) end)
    get(pid)
  end

#   def initialize(size)
#   @neurons = Array.new(size) { Neuron.new }
# end

end

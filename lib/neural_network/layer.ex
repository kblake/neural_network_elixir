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
end

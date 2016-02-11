defmodule NeuralNetwork.Connection do
  defstruct source: %{}, target: %{}, weight: 0.4 # make weight random at some point

  # def connection_for(source, target) do
  #   {:ok, %NeuralNet.Connection{source: source, target: target}}
  # end

  def start_link(name) do
    Agent.start_link(fn -> %NeuralNetwork.Connection{} end, name: name)
  end

  def get(name) do
    Agent.get(name, &(&1))
  end
end

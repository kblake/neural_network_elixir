defmodule NeuralNetwork.Connection do
  defstruct name: "", source: %{}, target: %{}, weight: 0.4 # make weight random at some point

  def start_link(connection_fields) do
    Agent.start_link(fn ->
      Map.merge(%NeuralNetwork.Connection{}, connection_fields)
    end, name: connection_fields.name)
  end

  def get(name), do: Agent.get(name, &(&1))

  def update(name, fields) do
    Agent.update(name, fn connection -> Map.merge(connection, fields) end)
  end

  def stop(name), do: Process.exit(Process.whereis(name), :shutdown)

  def connection_for(source, target) do
    NeuralNetwork.Connection.start_link(%{name: :connection})
    NeuralNetwork.Connection.update(:connection, %{source: source, target: target})
    NeuralNetwork.Connection.get(:connection)
  end
end

defmodule NeuralNetwork.Connection do
  alias NeuralNetwork.{Connection}

  defstruct pid: "", source_pid: nil, target_pid: nil, weight: 0.4 # make weight random at some point

  def start_link(connection_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %Connection{} end)
    update(pid, Map.merge(connection_fields, %{pid: pid}))
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def update(pid, fields) do
    Agent.update(pid, fn connection -> Map.merge(connection, fields) end)
    get(pid)
  end

  def stop(pid), do: Process.exit(Process.whereis(pid), :shutdown)

  def connection_for(source, target) do
    connection = start_link
    update(connection.pid, %{source_pid: source.pid, target_pid: target.pid})
  end
end

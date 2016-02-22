defmodule NeuralNetwork.Connection do
  alias NeuralNetwork.{Connection}

  defstruct pid: "", source_pid: nil, target_pid: nil, weight: 0.4 # make weight random at some point

  def start_link(connection_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %Connection{} end)
    update(pid, Map.merge(connection_fields, %{pid: pid}))

    {:ok, pid}
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def update(pid, fields) do
    Agent.update(pid, fn connection -> Map.merge(connection, fields) end)
  end

  def connection_for(source_pid, target_pid) do
    {:ok, pid} = start_link
    pid |> update(%{source_pid: source_pid, target_pid: target_pid})

    {:ok, pid}
  end
end

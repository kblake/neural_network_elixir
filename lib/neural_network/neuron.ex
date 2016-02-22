defmodule NeuralNetwork.Neuron do
  alias NeuralNetwork.{Neuron, Connection}

  defstruct pid: "", input: 0, output: 0, incoming: [], outgoing: [], bias?: false, delta: 0

  @learning_rate 0.3

  def learning_rate do
    @learning_rate
  end

  def start_link(neuron_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %Neuron{} end)
    update(pid, Map.merge(neuron_fields, %{pid: pid}))

    {:ok, pid}
  end

  def update(pid, neuron_fields) do
    Agent.update(pid, fn neuron -> Map.merge(neuron, neuron_fields) end)
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def connect(source_neuron_pid, target_neuron_pid) do
    {:ok, connection_pid} = Connection.connection_for(source_neuron_pid, target_neuron_pid)
    source_neuron_pid |> update(%{outgoing: get(source_neuron_pid).outgoing ++ [connection_pid]})
    target_neuron_pid |> update(%{incoming: get(target_neuron_pid).incoming ++ [connection_pid]})
  end

  def activation_function(input) do
    1 / (1 + :math.exp(-input))
  end

  defp sumf do
    fn(connection_pid, sum) ->
      connection = Connection.get(connection_pid)
      sum + get(connection.source_pid).output * connection.weight
    end
  end

  def activate(neuron_pid, value \\ nil) do
    neuron = get(neuron_pid) # just to make sure we are not getting a stale agent

    fields = if neuron.bias? do
      %{output: 1}
    else
      input = value || Enum.reduce(neuron.incoming, 0, sumf)
      %{input: input, output: activation_function(input)}
    end

    neuron_pid |> update(fields)
  end

  def train(neuron_pid, target_output \\ nil) do
    neuron = get(neuron_pid) # just to make sure we are not getting a stale agent

    if !neuron.bias? && !input_neuron?(neuron) do
      if output_neuron?(neuron) do
        # This is the derivative of the error function
        # not simply difference in output
        # http://whiteboard.ping.se/MachineLearning/BackProp

        neuron_pid |> update(%{delta: neuron.output - target_output})
      else
        neuron |> calculate_outgoing_delta
      end
    end

    get(neuron.pid) |> update_outgoing_weights
  end

  defp output_neuron?(neuron) do
    neuron.outgoing == []
  end

  defp input_neuron?(neuron) do
    neuron.incoming == []
  end

  defp calculate_outgoing_delta(neuron) do
    delta = Enum.reduce(neuron.outgoing, 0, fn connection_pid, sum ->
      connection = Connection.get(connection_pid)
      sum + connection.weight * get(connection.target_pid).delta
    end)

    neuron.pid |> update(%{delta: delta})
  end

  defp update_outgoing_weights(neuron) do
    for connection_pid <- neuron.outgoing do
      connection = Connection.get(connection_pid)
      gradient = neuron.output * get(connection.target_pid).delta
      updated_weight = connection.weight - gradient * learning_rate
      Connection.update(connection_pid, %{weight: updated_weight})
    end
  end
end

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
  end

  def update(pid, neuron_fields) do
    Agent.update(pid, fn neuron -> Map.merge(neuron, neuron_fields) end)
    get(pid)
  end

  def get(pid), do: Agent.get(pid, &(&1))

  def connect(source_neuron, target_neuron) do
    connection = Connection.connection_for(source_neuron, target_neuron)
    Neuron.update(source_neuron.pid, %{outgoing: Neuron.get(source_neuron.pid).outgoing ++ [connection]})
    Neuron.update(target_neuron.pid, %{incoming: Neuron.get(target_neuron.pid).incoming ++ [connection]})
    {:ok, Neuron.get(source_neuron.pid), Neuron.get(target_neuron.pid)}
  end

  def activation_function(input) do
    1 / (1 + :math.exp(-input))
  end

  defp sumf do
    fn(connection, sum) ->
      sum + Neuron.get(connection.source_pid).output * Connection.get(connection.pid).weight
    end
  end

  def activate(neuron, value \\ nil) do
    neuron = Neuron.get(neuron.pid) # just to make sure we are not getting a stale agent

    if neuron.bias? do
      Neuron.update(neuron.pid, %{output: 1})
    else
      input = value || Enum.reduce(neuron.incoming, 0, sumf)
      Neuron.update(neuron.pid, %{input: input, output: activation_function(input)})
    end

    # conveniently return updated neuron
    Neuron.get(neuron.pid)
  end

  def train(neuron, target_output \\ nil) do
    neuron = Neuron.get(neuron.pid) # just to make sure we are not getting a stale agent

    if !neuron.bias? && !input_neuron?(neuron) do
      if output_neuron?(neuron) do
        # This is the derivative of the error function
        # not simply difference in output
        # http://whiteboard.ping.se/MachineLearning/BackProp

        Neuron.update(neuron.pid, %{delta: neuron.output - target_output})
      else
        neuron |> calculate_outgoing_delta
      end
    end

    Neuron.get(neuron.pid) |> update_outgoing_weights

    # conveniently return updated neuron
    Neuron.get(neuron.pid)
  end

  defp output_neuron?(neuron) do
    neuron.outgoing == []
  end

  defp input_neuron?(neuron) do
    neuron.incoming == []
  end

  defp calculate_outgoing_delta(neuron) do
    delta = Enum.reduce(neuron.outgoing, 0, fn connection, sum ->
      sum + Connection.get(connection.pid).weight * Neuron.get(connection.target_pid).delta
    end)

    Neuron.update(neuron.pid, %{delta: delta})
  end

  defp update_outgoing_weights(neuron) do
    for connection <- neuron.outgoing do
      gradient = neuron.output * Neuron.get(connection.target_pid).delta
      updated_weight = Connection.get(connection.pid).weight - gradient * learning_rate
      Connection.update(connection.pid, %{weight: updated_weight})
    end
  end
end

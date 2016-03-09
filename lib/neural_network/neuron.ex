defmodule NeuralNetwork.Neuron do
  @moduledoc """
  A neuron makes up a network. It's purpose is to sum its inputs
  and compute an output. During training the neurons adjust weights
  of its outgoing connections to other neurons.
  """

  alias NeuralNetwork.{Neuron, Connection}

  defstruct pid: nil, input: 0, output: 0, incoming: [], outgoing: [], bias?: false, delta: 0

  @learning_rate 0.3

  def learning_rate do
    @learning_rate
  end

  @doc """
  Create a neuron agent
  """
  def start_link(neuron_fields \\ %{}) do
    {:ok, pid} = Agent.start_link(fn -> %Neuron{} end)
    update(pid, Map.merge(neuron_fields, %{pid: pid}))

    {:ok, pid}
  end

  @doc """
  ## Pass in the pid, and a map to update values of a neuron
      iex> {:ok, pid} = NeuralNetwork.Neuron.start_link
      ...> NeuralNetwork.Neuron.update(pid, %{input: 3, output: 2, incoming: [1], outgoing: [2], bias?: true, delta: 1})
      ...> neuron = NeuralNetwork.Neuron.get(pid)
      ...> neuron.output
      2
  """
  def update(pid, neuron_fields) do
    Agent.update(pid, &(Map.merge(&1, neuron_fields)))
  end

  @doc """
  Lookup and return a neuron
  """
  def get(pid), do: Agent.get(pid, &(&1))

  @doc """
  Connect two neurons
  """
  def connect(source_neuron_pid, target_neuron_pid) do
    {:ok, connection_pid} = Connection.connection_for(source_neuron_pid, target_neuron_pid)
    source_neuron_pid |> update(%{outgoing: get(source_neuron_pid).outgoing ++ [connection_pid]})
    target_neuron_pid |> update(%{incoming: get(target_neuron_pid).incoming ++ [connection_pid]})
  end

  @doc """
  Sigmoid function. See more at: https://en.wikipedia.org/wiki/Sigmoid_function

  ## Example

      iex> NeuralNetwork.Neuron.activation_function(1)
      0.7310585786300049
  """
  def activation_function(input) do
    1 / (1 + :math.exp(-input))
  end

  defp sumf do
    fn(connection_pid, sum) ->
      connection = Connection.get(connection_pid)
      sum + get(connection.source_pid).output * connection.weight
    end
  end

  @doc """
  Activate a neuron. Set the input value and compute the output
  Input neuron: output will always equal their input value
  Bias neuron: output is always 1.
  Other neurons: will squash their input value to compute output
  """
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

  @doc """
  Backprop using the delta.
  Set the neuron's delta value.
  """
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

  # https://en.m.wikipedia.org/wiki/Delta_rule
  defp update_outgoing_weights(neuron) do
    for connection_pid <- neuron.outgoing do
      connection = Connection.get(connection_pid)
      gradient = neuron.output * get(connection.target_pid).delta
      updated_weight = connection.weight - gradient * learning_rate
      Connection.update(connection_pid, %{weight: updated_weight})
    end
  end
end

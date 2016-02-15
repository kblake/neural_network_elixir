defmodule NeuralNetwork.Neuron do
  alias NeuralNetwork.{Neuron, Connection}

  defstruct name: "", input: 0, output: 0, incoming: [], outgoing: [], bias?: false, error: 0, delta: 0

  @learning_rate 0.3

  def learning_rate do
    @learning_rate
  end

  def start_link(neuron_fields) do
    Agent.start_link(fn ->
      Map.merge(%Neuron{}, neuron_fields)
    end, name: neuron_fields.name)
  end

  def update(name, neuron_fields) do
    Agent.update(name, fn neuron -> Map.merge(neuron, neuron_fields) end)
  end

  def get(name), do: Agent.get(name, &(&1))

  def connect(source_neuron, target_neuron) do
    connection = Connection.connection_for(source_neuron, target_neuron)
    Neuron.update(source_neuron.name, %{outgoing: Neuron.get(source_neuron.name).outgoing ++ [connection]})
    Neuron.update(target_neuron.name, %{incoming: Neuron.get(target_neuron.name).incoming ++ [connection]})
    {:ok, Neuron.get(source_neuron.name), Neuron.get(target_neuron.name)}
  end

  def activation_function(input) do
    1 / (1 + :math.exp(-input))
  end

  defp sumf do
    fn(connection, sum) ->
      sum + Neuron.get(connection.source_name).output * Connection.get(connection.name).weight
    end
  end

  def activate(neuron, value \\ nil) do
    if Neuron.get(neuron.name).bias? do
      Neuron.update(neuron.name, %{output: 1})
    else
      input = value || Enum.reduce(Neuron.get(neuron.name).incoming, 0, sumf)
      Neuron.update(neuron.name, %{input: input, output: activation_function(input)})
    end

    # conveniently return updated neuron
    Neuron.get(neuron.name)
  end

  def train(neuron, target_output \\ nil) do
    if output_neuron?(neuron) do
      error = target_output - Neuron.get(neuron.name).output

      Neuron.update(neuron.name,
                    %{
                      error: error,
                      delta: -error * input_derivative(Neuron.get(neuron.name).input)
                    })
    else
      neuron |> calculate_outgoing_delta
    end

    neuron |> update_outgoing_weights

    # conveniently return updated neuron
    Neuron.get(neuron.name)
  end

  defp output_neuron?(neuron) do
    Neuron.get(neuron.name).outgoing == []
  end

  defp input_derivative(input_value) do
    val = 1/(1 + :math.exp(-input_value))
    val * (1 - val)
  end

  defp calculate_outgoing_delta(neuron) do
    delta = Enum.reduce(Neuron.get(neuron.name).outgoing, 0, fn connection, sum ->
      sum + input_derivative(Neuron.get(neuron.name).input) * Connection.get(connection.name).weight * Neuron.get(connection.target_name).delta
    end)

    Neuron.update(neuron.name, %{delta: delta})
  end

  defp update_outgoing_weights(neuron) do
    for connection <- Neuron.get(neuron.name).outgoing do
      gradient = Neuron.get(neuron.name).output * Neuron.get(connection.target_name).delta
      updated_weight = Connection.get(connection.name).weight - gradient * learning_rate
      Connection.update(connection.name, %{weight: updated_weight})
    end
  end
end

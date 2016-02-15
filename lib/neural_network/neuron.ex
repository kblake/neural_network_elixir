defmodule NeuralNetwork.Neuron do
  alias NeuralNetwork.{Neuron, Connection}

  defstruct name: "", input: 0, output: 0, incoming: [], outgoing: [], bias?: false

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
    Neuron.update(source_neuron.name, %{outgoing: source_neuron.outgoing ++ [connection]})
    Neuron.update(target_neuron.name, %{incoming: target_neuron.incoming ++ [connection]})
    {:ok, Neuron.get(source_neuron.name), Neuron.get(target_neuron.name)}
  end

  def activation_function(input) do
    1 / (1 + :math.exp(-input))
  end

  defp sumf do
    fn(connection, sum) ->
      #############################
      # TODO: explore just storing name for incoming and outgoing connections!!
      ##################################
      source = Neuron.get(connection.source)
      sum + source.output * connection.weight
    end
  end

  def activate(neuron, value \\ nil) do
    if neuron.bias? do
      Neuron.update(neuron.name, %{output: 1})
    else
      input = value || Enum.reduce(neuron.incoming, 0, sumf)
      Neuron.update(neuron.name, %{input: input, output: activation_function(input)})
    end

    # conveniently return updated neuron
    Neuron.get(neuron.name)
  end
end

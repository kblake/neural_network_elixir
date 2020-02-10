defmodule NeuralNetwork.Network do
  @moduledoc """
  Contains layers which makes up a matrix of neurons.
  """

  alias NeuralNetwork.{Layer, Network, Neuron, LossFunction}

  defstruct pid: nil,
            input_layer: nil,
            hidden_layers: [],
            output_layer: nil,
            activation: nil,
            error: 0

  @options %{activation: :relu}

  @doc """
  Pass in layer sizes which will generate the layers for the network.
  The first number represents the number of neurons in the input layer.
  The last number represents the number of neurons in the output layer.
  [Optionally] The middle numbers represent the number of neurons for hidden layers.
  """
  def start_link(layer_sizes \\ [], options \\ @options) do
    {:ok, pid} = Agent.start_link(fn -> %Network{} end)

    layers =
      map_layers(
        input_neurons(layer_sizes),
        hidden_neurons(layer_sizes),
        output_neurons(layer_sizes)
      )

    pid |> update(layers)
    pid |> connect_layers
    pid |> update_activation(options.activation)
    {:ok, pid}
  end

  @doc """
  Return the network by pid.
  """
  def model(pid), do: Agent.get(pid, & &1)

  @doc """
  Update the network layers.
  """
  def update(pid, fields) do
    fields = Map.merge(fields, %{pid: pid})
    Agent.update(pid, &Map.merge(&1, fields))
  end

  @doc """
  Activation function for the hidden layer.

  ‘identity’, no-op activation, useful to implement linear bottleneck, returns f(x) = x
  ‘sigmoid’, the logistic sigmoid function, returns f(x) = 1 / (1 + exp(-x)).
  ‘tanh’, the hyperbolic tan function, returns f(x) = tanh(x).
  ‘relu’, the rectified linear unit function, returns f(x) = max(0, x)
  """
  def update_activation(pid, activation) do
    fields = Map.merge(pid |> Network.model, %{activation: activation})
    Agent.update(pid, &Map.merge(&1, fields))
  end

  defp input_neurons(layer_sizes) do
    size = layer_sizes |> List.first()
    {:ok, pid} = Layer.start_link(%{neuron_size: size})
    pid
  end

  defp hidden_neurons(layer_sizes) do
    layer_sizes
    |> hidden_layer_slice
    |> Enum.map(fn size ->
      {:ok, pid} = Layer.start_link(%{neuron_size: size})
      pid
    end)
  end

  defp output_neurons(layer_sizes) do
    size = layer_sizes |> List.last()
    {:ok, pid} = Layer.start_link(%{neuron_size: size})
    pid
  end

  defp hidden_layer_slice(layer_sizes) do
    layer_sizes
    |> Enum.slice(1..(length(layer_sizes) - 2))
  end

  defp connect_layers(pid) do
    layers = pid |> Network.model() |> flatten_layers

    layers
    |> Stream.with_index()
    |> Enum.each(fn tuple ->
      {layer, index} = tuple
      next_index = index + 1

      if Enum.at(layers, next_index) do
        Layer.connect(layer, Enum.at(layers, next_index))
      end
    end)
  end

  defp flatten_layers(network) do
    [network.input_layer] ++ network.hidden_layers ++ [network.output_layer]
  end

  @doc """
  Activate the network given list of input values.
  """
  def activate(network, input_values) do
    network.input_layer |> Layer.activate(network.activation, input_values)

    Enum.each(network.hidden_layers, fn hidden_layer ->
      hidden_layer |> Layer.activate(network.activation)
    end)

    network.output_layer |> Layer.activate(:sigmoid)
  end

  @doc """
  Generates output predictions for the input samples.
  """
  def predict(network_pid, input_data) do
    network_pid |> forward(input_data)
    network_pid |> get_output_data()
  end

  defp get_output_data(network_pid) do
    with model <- network_pid |> Network.model() do
      model.output_layer
      |> Layer.get()
      |> Layer.neurons_output()
    end
  end

  @doc """
  Forward
  """
  defp forward(network_pid, input_data) do
    network_pid |> Network.model() |> Network.activate(input_data)
  end

  @doc """
  Backpropagation
  """
  def backward(network_pid, output_data) do
    network_pid
    |> Network.model()
    |> Network.learn(output_data)
  end

  @doc """
  Trains the model for a fixed number of epochs.
  """
  def fit(network_pid, data, options \\ %{}) do
    epochs = options.epochs
    log_freqs = options.log_freqs
    data_length = length(data)

    for epoch <- 0..epochs do
      average_error =
        Enum.reduce(data, 0, fn sample, sum ->
          network_pid |> forward(sample.input)
          network_pid |> backward(sample.output)

          sum + Network.model(network_pid).error / data_length
        end)

      if rem(epoch, log_freqs) == 0 || epoch + 1 == epochs do
        IO.puts("Epoch: #{epoch}   Error: #{unexponential(average_error)}")
      end
    end
    network_pid
  end

  defp unexponential(average_error) do
    :erlang.float_to_binary(average_error, [{:decimals, 19}, :compact])
  end

  @doc """
  Set the network error and output layer's deltas propagate them
  backward through the network. (Back Propagation!)

  The input layer is skipped (no use for deltas).
  """
  def learn(network, target_outputs) do
    network.output_layer |> Layer.get() |> Layer.train(target_outputs)
    network.pid |> update(%{error: error_function(network, target_outputs)})

    network.hidden_layers
    |> Enum.reverse()
    |> Enum.each(fn layer_pid ->
      layer_pid |> Layer.get() |> Layer.train(target_outputs)
    end)

    network.input_layer |> Layer.get() |> Layer.train(target_outputs)
  end

  # https://en.wikipedia.org/wiki/Backpropagation#Derivation
  defp error_function(network, target_outputs) do
    (Layer.get(network.output_layer).neurons
     |> Stream.with_index()
     |> Enum.reduce(0, fn {neuron, index}, sum ->
       target_output = Enum.at(target_outputs, index)
       actual_output = Neuron.get(neuron).output
       LossFunction.squared_error(sum, target_output, actual_output)
     end)) / length(Layer.get(network.output_layer).neurons)
  end

  # defp squared_error(sum, target_output, actual_output) do
  #   sum + 0.5 * :math.pow(target_output - actual_output, 2)
  # end

  defp map_layers(input_layer, hidden_layers, output_layer) do
    %{
      input_layer: input_layer,
      output_layer: output_layer,
      hidden_layers: hidden_layers
    }
  end
end

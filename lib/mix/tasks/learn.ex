defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Run the neural network app"

  def run(args) do
  #   IO.puts "NETWORK"
  #   network = NeuralNetwork.Network.start_link([3,2,1])
  #   network = NeuralNetwork.Network.activate(network, [1,2,3])

  #   IO.puts "INPUT"
  #   for neuron <- network.input_layer.neurons do
  #     IO.puts "in #{neuron.input}  out #{neuron.output}"
  #   end

  #   IO.puts "HIDDEN"
  #   for hidden_layer <- network.hidden_layers do
  #     for neuron <- hidden_layer.neurons do
  #       IO.puts "in #{neuron.input}  out #{neuron.output}"
  #     end
  #   end

  #   IO.puts "OUTPUT"
  #   for neuron <- network.output_layer.neurons do
  #     IO.puts "in #{neuron.input}  out #{neuron.output}"
  #   end


  #   IO.puts ""
  #   IO.puts "********************************************************"
  #   IO.puts "********************************************************"
  #   IO.puts ""


  #   neuronA = NeuralNetwork.Neuron.start_link
  #   neuronB = NeuralNetwork.Neuron.start_link

  #   {:ok, neuronA, neuronB} = NeuralNetwork.Neuron.connect(neuronA, neuronB)

  #   for n <- 0..10000 do
  #     neuronA = NeuralNetwork.Neuron.get(neuronA.pid) |> NeuralNetwork.Neuron.activate(2)
  #     neuronB = NeuralNetwork.Neuron.get(neuronB.pid) |> NeuralNetwork.Neuron.activate

  #     neuronB = neuronB |> NeuralNetwork.Neuron.train(1)
  #     neuronA = neuronA |> NeuralNetwork.Neuron.train

  #     if n == 0 || rem(n, 1000) == 0 do
  #       IO.puts "epoch: #{n} error: #{NeuralNetwork.Neuron.get(neuronB.pid).error}"
  #     end
  #   end

  # end

    network = NeuralNetwork.Network.start_link([2,1])
    data = NeuralNetwork.DataFactory.or_gate
    NeuralNetwork.Trainer.train(network, data, %{epochs: 10_000, log_freqs: 1000})
  end
end

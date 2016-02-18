defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Run the neural network app"

  def run(args) do
    #neuronA = %NeuralNet.Neuron{}
    #neuronB = %NeuralNet.Neuron{}

    # {:ok, neuronA, neuronB} = NeuralNet.Neuron.connect(neuronA, neuronB)

    #neuronA = NeuralNet.Neuron.activate(neuronA)
    #IO.puts neuronA.output

    #neuronB = NeuralNet.Neuron.activate(neuronB, 1)
    #IO.puts neuronB.output

    #layer = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{}, %NeuralNet.Neuron{}]}
    #IO.inspect layer.neurons

    #inputs = [1,1,1]
    # {:ok, layer} = NeuralNet.Layer.activate(layer, inputs)

    #IO.inspect layer.neurons

    #input_layer = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{}, %NeuralNet.Neuron{}]}
    #output_layer = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{}, %NeuralNet.Neuron{}]}

    # {:ok, input_layer, output_layer} = %NeuralNet.Layer.connect(input_layer, output_layer)

    #############################################################################
    #############################################################################

  #   neuronA = NeuralNetwork::Neuron.new
  #   neuronB = NeuralNetwork::Neuron.new

  #   neuronA.connect(neuronB)

  #   10000.times do |n|
  #     neuronA.activate(2)
  #     neuronB.activate

  #     #puts "A out: #{neuronA.output}"
  #     #puts "B out: #{neuronB.output}"

  #     neuronB.train(1)
  #     neuronA.train

  #     if n == 0 || n % 1000 == 0
  #      puts "epoch: #{n} error: #{neuronB.error}"
  #     end
  #     #puts "A error/delta: #{neuronA.error}/#{neuronA.delta}"
  #     #puts "B error/delta: #{neuronB.error}/#{neuronB.delta}"
  #   end


    #puts
    #puts "*" * 80
    #puts "NETWORK"
    #net = NeuralNetwork::Network.new([3,2,1])
    #net.activate([1,2, 3])

    #puts "INPUT"
    #net.input_layer.neurons.each do |n|
    #puts "in #{n.input}  out #{n.output}"
    #end


    #puts "HIDDEN"
    #net.hidden_layers.each do |l|
    #l.neurons.each do |n|
    #puts "in #{n.input}  out #{n.output}"
    #end
    #end

    #puts "OUTPUT"
    #net.output_layer.neurons.each do |n|
    #puts "in #{n.input}  out #{n.output}"
    #end


    neuronA = NeuralNetwork.Neuron.start_link
    neuronB = NeuralNetwork.Neuron.start_link

    {:ok, neuronA, neuronB} = NeuralNetwork.Neuron.connect(neuronA, neuronB)

    for n <- 0..10000 do
      neuronA = NeuralNetwork.Neuron.get(neuronA.pid) |> NeuralNetwork.Neuron.activate(2)
      neuronB = NeuralNetwork.Neuron.get(neuronB.pid) |> NeuralNetwork.Neuron.activate

      neuronB = neuronB |> NeuralNetwork.Neuron.train(1)
      neuronA = neuronA |> NeuralNetwork.Neuron.train

      if n == 0 || rem(n, 1000) == 0 do
        # IO.puts "A out: #{neuronA.output}"
        # IO.puts "B out: #{NeuralNetwork.Neuron.get(neuronB.pid).output}"
        IO.puts "epoch: #{n} error: #{NeuralNetwork.Neuron.get(neuronB.pid).error}"
      end
    end

  end
end

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


    NeuralNetwork.Neuron.start_link(%{name: :a})
    NeuralNetwork.Neuron.start_link(%{name: :b})
    neuronA = NeuralNetwork.Neuron.get((:a))
    neuronB = NeuralNetwork.Neuron.get((:b))


     {:ok, neuronA, neuronB} = NeuralNetwork.Neuron.connect(neuronA, neuronB)
     # IO.puts List.first(neuronB.incoming).source.output
     # IO.puts List.first(neuronB.incoming).weight

    for i <- 1..1 do
      IO.puts "neuronA activate =============="
      neuronA = NeuralNetwork.Neuron.activate(neuronA, 2)
      IO.puts "neuronA output: #{neuronA.output}"

      IO.puts "neuronB activate =============="
      neuronB = NeuralNetwork.Neuron.activate(neuronB)

      # IO.puts "A out: #{neuronA.output}"
      IO.puts "B out: #{neuronB.output}"
    end

  end
end

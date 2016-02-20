defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Run the neural network app"

  def run(args) do
    network = NeuralNetwork.Network.start_link([2,1])
    data = NeuralNetwork.DataFactory.or_gate
    NeuralNetwork.Trainer.train(network, data, %{epochs: 10_000, log_freqs: 1000})
  end
end

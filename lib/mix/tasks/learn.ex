defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Run the neural network app"

  def run(args) do
    gate_name = args |> List.first
    IO.puts ""

    if NeuralNetwork.DataFactory.gate_exists?(gate_name) do
      {:ok, network_pid} = NeuralNetwork.Network.start_link([2,1])
      data = NeuralNetwork.DataFactory.gate_for(gate_name)
      IO.puts "#{String.upcase(gate_name)} gate learning *********************************************"
      NeuralNetwork.Trainer.train(network_pid, data, %{epochs: 10_000, log_freqs: 1000})
      IO.puts "**************************************************************"
    else
      IO.puts "Cannot learn: '#{gate_name}'. Try one of these instead: #{NeuralNetwork.DataFactory.gate_names}"
    end

    IO.puts ""
  end
end

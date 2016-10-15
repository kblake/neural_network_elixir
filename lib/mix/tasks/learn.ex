defmodule Mix.Tasks.Learn do
  use Mix.Task

  alias NeuralNetwork.{DataFactory, Network, Trainer}

  @shortdoc "Run the neural network app"

  def run(args) do
    gate_name = args |> List.first
    IO.puts ""

    if DataFactory.gate_exists?(gate_name) do
      {:ok, network_pid} = Network.start_link([2,1])
      data = DataFactory.gate_for(gate_name)
      IO.puts "#{String.upcase(gate_name)} gate learning *********************************************"
      Trainer.train(network_pid, data, %{epochs: 10_000, log_freqs: 1000})
      IO.puts "**************************************************************"
    else
      IO.puts "Cannot learn: '#{gate_name}'. Try one of these instead: #{DataFactory.gate_names}"
    end

    IO.puts ""
  end
end

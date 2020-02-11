defmodule Mix.Tasks.Learn do
  @moduledoc """
  Mix task to run the neural network using various data sets.
  """

  use Mix.Task

  alias NeuralNetwork.{DataFactory, Network}

  @shortdoc "Run the neural network app"

  def run(args) do
    destructure [gate_name, epoch_count], args
    epoch_count = (epoch_count && :erlang.binary_to_integer(epoch_count)) || 10_000

    IO.puts("")

    if DataFactory.gate_exists?(gate_name) do
      {:ok, network_pid} = Network.start_link([2, 1], %{activation: :relu})
      data = DataFactory.gate_for(gate_name)

      IO.puts(
        "#{String.upcase(gate_name)} gate learning *********************************************"
      )

      Network.fit(network_pid, data, %{epochs: epoch_count, log_freqs: 1000})
      IO.puts("**************************************************************")
    else
      IO.puts(
        "Cannot learn: '#{gate_name}'. Try one of these instead: #{DataFactory.gate_names()}"
      )
    end

    IO.puts("")
  end
end

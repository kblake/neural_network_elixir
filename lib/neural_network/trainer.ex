defmodule NeuralNetwork.Trainer do
  @moduledoc """
  Runs a network as classified by data its given.
  """

  alias NeuralNetwork.{Network}

  def train(network_pid, data, options \\ %{}) do
    epochs      = options.epochs
    log_freqs   = options.log_freqs
    data_length = length(data)

    for epoch <- 0..epochs do
      average_error = Enum.reduce(data, 0, fn sample, sum ->
        network_pid |> Network.get |> Network.activate(sample.input)
        network_pid |> Network.get |> Network.train(sample.output)

        sum + Network.get(network_pid).error/data_length
      end)

      if rem(epoch, log_freqs) == 0 || epoch + 1 == epochs do
        IO.puts "Epoch: #{epoch}   Error: #{unexponential(average_error)}"
      end
    end
  end

  defp unexponential(average_error) do
    Float.to_string average_error, [decimals: 19, compact: true]
  end
end

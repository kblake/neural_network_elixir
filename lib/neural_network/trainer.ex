defmodule NeuralNetwork.Trainer do
  alias NeuralNetwork.{Network}

  def train(network, data, options \\ %{}) do
    epochs      = options.epochs
    log_freqs   = options.log_freqs
    data_length = length(data)

    for epoch <- 0..epochs do
      average_error = Enum.reduce(data, 0, fn sample, sum ->
        network = network
        |> Network.activate(sample.input)
        |> Network.train(sample.output)

        sum + network.error/data_length
      end)

      if rem(epoch, log_freqs) == 0 || epoch + 1 == epochs do
        IO.puts "Epoch: #{epoch}   Error: #{unexponential(average_error)}"
      end
    end
  end

  defp unexponential(average_error) do
    :erlang.float_to_binary(average_error, [{ :decimals, 19 }])
  end
end

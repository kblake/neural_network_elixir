defmodule NeuralNetwork.Thinker do
  @moduledoc """
  Predict data.
  """

  alias NeuralNetwork.{Network, Layer}

  def predict(network_pid, input) do
    model =
      network_pid
      |> Network.get()

    model
    |> Network.activate(input)

    model.output_layer
    |> Layer.get()
    |> Layer.neurons_output()
  end
end

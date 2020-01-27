defmodule NeuralNetwork.Activation do
  @moduledoc """
  Activation methods to predict
  """

  @doc """
  """
  def calculate_output(:softmax, input), do: softmax(input)
  def calculate_output(:sigmoid, input), do: sigmoid(input)
  def calculate_output(:relu, input), do: relu(input)
  def calculate_output(:identity, input), do: input
  def calculate_output(:tanh, input), do: tanh(input)

  defp softmax([input]), do: softmax(input)
  defp softmax(input) when is_list(input) do
    c = Enum.max(input)
    x1 = Enum.map(input, fn(y) -> y-c end)
    sum = listsum(x1)
    Enum.map(x1, fn(y) -> :math.exp(y)/sum end)
  end
  defp softmax(input), do: input

  defp listsum([]), do: 0
  defp listsum([x|xs]), do: :math.exp(x) + listsum(xs)

  defp sigmoid(input), do: 1 / (1 + :math.exp(-input))

  defp relu(input) when input <= 0, do: 0
  defp relu(input) when input > 0, do: input

  defp tanh(input), do: :math.tanh(input)
end

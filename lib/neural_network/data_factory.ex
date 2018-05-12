defmodule NeuralNetwork.DataFactory do
  @moduledoc """
  Factory of data sets for the network to learn.
  Data sets: or, and, xor, nand
  """

  def gate_for(name) do
    {:ok, data} = Map.fetch(gates(), String.to_atom(name))
    data
  end

  def gates do
    %{
      or: or_gate(),
      and: and_gate(),
      xor: xor_gate(),
      nand: nand_gate(),
      iris_flower: iris_flower_gate()
    }
  end

  def gate_names do
    gates() |> Map.keys() |> Enum.join(", ")
  end

  def gate_exists?(name) do
    Map.has_key?(gates(), String.to_atom(name))
  end

  @or_gate [
    %{input: [0, 0], output: [0]},
    %{input: [0, 1], output: [1]},
    %{input: [1, 0], output: [1]},
    %{input: [1, 1], output: [1]}
  ]

  @and_gate [
    %{input: [0, 0], output: [0]},
    %{input: [0, 1], output: [0]},
    %{input: [1, 0], output: [0]},
    %{input: [1, 1], output: [1]}
  ]

  @xor_gate [
    %{input: [0, 0], output: [0]},
    %{input: [0, 1], output: [1]},
    %{input: [1, 0], output: [1]},
    %{input: [1, 1], output: [0]}
  ]

  @nand_gate [
    %{input: [0, 0], output: [1]},
    %{input: [0, 1], output: [1]},
    %{input: [1, 0], output: [1]},
    %{input: [1, 1], output: [0]}
  ]

  @doc """
  Iris flower data set.  The output labels are: Iris setosa, Iris versicolor,
  Iris virginica. https://www.wikiwand.com/en/Iris_flower_data_set
  4 inputs, 3 output, 150 samples
  """
  @iris_flower [
    %{input: [5.1, 3.5, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [4.9, 3.0, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [4.7, 3.2, 1.3, 0.2], output: [1, 0, 0]},
    %{input: [4.6, 3.1, 1.5, 0.2], output: [1, 0, 0]},
    %{input: [5.0, 3.6, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [5.4, 3.9, 1.7, 0.4], output: [1, 0, 0]},
    %{input: [4.6, 3.4, 1.4, 0.3], output: [1, 0, 0]},
    %{input: [5.0, 3.4, 1.5, 0.2], output: [1, 0, 0]},
    %{input: [4.4, 2.9, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [4.9, 3.1, 1.5, 0.1], output: [1, 0, 0]},
    %{input: [5.4, 3.7, 1.5, 0.2], output: [1, 0, 0]},
    %{input: [4.8, 3.4, 1.6, 0.2], output: [1, 0, 0]},
    %{input: [4.8, 3.0, 1.4, 0.1], output: [1, 0, 0]},
    %{input: [4.3, 3.0, 1.1, 0.1], output: [1, 0, 0]},
    %{input: [5.8, 4.0, 1.2, 0.2], output: [1, 0, 0]},
    %{input: [5.7, 4.4, 1.5, 0.4], output: [1, 0, 0]},
    %{input: [5.4, 3.9, 1.3, 0.4], output: [1, 0, 0]},
    %{input: [5.1, 3.5, 1.4, 0.3], output: [1, 0, 0]},
    %{input: [5.7, 3.8, 1.7, 0.3], output: [1, 0, 0]},
    %{input: [5.1, 3.8, 1.5, 0.3], output: [1, 0, 0]},
    %{input: [5.4, 3.4, 1.7, 0.2], output: [1, 0, 0]},
    %{input: [5.1, 3.7, 1.5, 0.4], output: [1, 0, 0]},
    %{input: [4.6, 3.6, 1.0, 0.2], output: [1, 0, 0]},
    %{input: [5.1, 3.3, 1.7, 0.5], output: [1, 0, 0]},
    %{input: [4.8, 3.4, 1.9, 0.2], output: [1, 0, 0]},
    %{input: [5.0, 3.0, 1.6, 0.2], output: [1, 0, 0]},
    %{input: [5.0, 3.4, 1.6, 0.4], output: [1, 0, 0]},
    %{input: [5.2, 3.5, 1.5, 0.2], output: [1, 0, 0]},
    %{input: [5.2, 3.4, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [4.7, 3.2, 1.6, 0.2], output: [1, 0, 0]},
    %{input: [4.8, 3.1, 1.6, 0.2], output: [1, 0, 0]},
    %{input: [5.4, 3.4, 1.5, 0.4], output: [1, 0, 0]},
    %{input: [5.2, 4.1, 1.5, 0.1], output: [1, 0, 0]},
    %{input: [5.5, 4.2, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [4.9, 3.1, 1.5, 0.1], output: [1, 0, 0]},
    %{input: [5.0, 3.2, 1.2, 0.2], output: [1, 0, 0]},
    %{input: [5.5, 3.5, 1.3, 0.2], output: [1, 0, 0]},
    %{input: [4.9, 3.1, 1.5, 0.1], output: [1, 0, 0]},
    %{input: [4.4, 3.0, 1.3, 0.2], output: [1, 0, 0]},
    %{input: [5.1, 3.4, 1.5, 0.2], output: [1, 0, 0]},
    %{input: [5.0, 3.5, 1.3, 0.3], output: [1, 0, 0]},
    %{input: [4.5, 2.3, 1.3, 0.3], output: [1, 0, 0]},
    %{input: [4.4, 3.2, 1.3, 0.2], output: [1, 0, 0]},
    %{input: [5.0, 3.5, 1.6, 0.6], output: [1, 0, 0]},
    %{input: [5.1, 3.8, 1.9, 0.4], output: [1, 0, 0]},
    %{input: [4.8, 3.0, 1.4, 0.3], output: [1, 0, 0]},
    %{input: [5.1, 3.8, 1.6, 0.2], output: [1, 0, 0]},
    %{input: [4.6, 3.2, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [5.3, 3.7, 1.5, 0.2], output: [1, 0, 0]},
    %{input: [5.0, 3.3, 1.4, 0.2], output: [1, 0, 0]},
    %{input: [7.0, 3.2, 4.7, 1.4], output: [0, 1, 0]},
    %{input: [6.4, 3.2, 4.5, 1.5], output: [0, 1, 0]},
    %{input: [6.9, 3.1, 4.9, 1.5], output: [0, 1, 0]},
    %{input: [5.5, 2.3, 4.0, 1.3], output: [0, 1, 0]},
    %{input: [6.5, 2.8, 4.6, 1.5], output: [0, 1, 0]},
    %{input: [5.7, 2.8, 4.5, 1.3], output: [0, 1, 0]},
    %{input: [6.3, 3.3, 4.7, 1.6], output: [0, 1, 0]},
    %{input: [4.9, 2.4, 3.3, 1.0], output: [0, 1, 0]},
    %{input: [6.6, 2.9, 4.6, 1.3], output: [0, 1, 0]},
    %{input: [5.2, 2.7, 3.9, 1.4], output: [0, 1, 0]},
    %{input: [5.0, 2.0, 3.5, 1.0], output: [0, 1, 0]},
    %{input: [5.9, 3.0, 4.2, 1.5], output: [0, 1, 0]},
    %{input: [6.0, 2.2, 4.0, 1.0], output: [0, 1, 0]},
    %{input: [6.1, 2.9, 4.7, 1.4], output: [0, 1, 0]},
    %{input: [5.6, 2.9, 3.6, 1.3], output: [0, 1, 0]},
    %{input: [6.7, 3.1, 4.4, 1.4], output: [0, 1, 0]},
    %{input: [5.6, 3.0, 4.5, 1.5], output: [0, 1, 0]},
    %{input: [5.8, 2.7, 4.1, 1.0], output: [0, 1, 0]},
    %{input: [6.2, 2.2, 4.5, 1.5], output: [0, 1, 0]},
    %{input: [5.6, 2.5, 3.9, 1.1], output: [0, 1, 0]},
    %{input: [5.9, 3.2, 4.8, 1.8], output: [0, 1, 0]},
    %{input: [6.1, 2.8, 4.0, 1.3], output: [0, 1, 0]},
    %{input: [6.3, 2.5, 4.9, 1.5], output: [0, 1, 0]},
    %{input: [6.1, 2.8, 4.7, 1.2], output: [0, 1, 0]},
    %{input: [6.4, 2.9, 4.3, 1.3], output: [0, 1, 0]},
    %{input: [6.6, 3.0, 4.4, 1.4], output: [0, 1, 0]},
    %{input: [6.8, 2.8, 4.8, 1.4], output: [0, 1, 0]},
    %{input: [6.7, 3.0, 5.0, 1.7], output: [0, 1, 0]},
    %{input: [6.0, 2.9, 4.5, 1.5], output: [0, 1, 0]},
    %{input: [5.7, 2.6, 3.5, 1.0], output: [0, 1, 0]},
    %{input: [5.5, 2.4, 3.8, 1.1], output: [0, 1, 0]},
    %{input: [5.5, 2.4, 3.7, 1.0], output: [0, 1, 0]},
    %{input: [5.8, 2.7, 3.9, 1.2], output: [0, 1, 0]},
    %{input: [6.0, 2.7, 5.1, 1.6], output: [0, 1, 0]},
    %{input: [5.4, 3.0, 4.5, 1.5], output: [0, 1, 0]},
    %{input: [6.0, 3.4, 4.5, 1.6], output: [0, 1, 0]},
    %{input: [6.7, 3.1, 4.7, 1.5], output: [0, 1, 0]},
    %{input: [6.3, 2.3, 4.4, 1.3], output: [0, 1, 0]},
    %{input: [5.6, 3.0, 4.1, 1.3], output: [0, 1, 0]},
    %{input: [5.5, 2.5, 4.0, 1.3], output: [0, 1, 0]},
    %{input: [5.5, 2.6, 4.4, 1.2], output: [0, 1, 0]},
    %{input: [6.1, 3.0, 4.6, 1.4], output: [0, 1, 0]},
    %{input: [5.8, 2.6, 4.0, 1.2], output: [0, 1, 0]},
    %{input: [5.0, 2.3, 3.3, 1.0], output: [0, 1, 0]},
    %{input: [5.6, 2.7, 4.2, 1.3], output: [0, 1, 0]},
    %{input: [5.7, 3.0, 4.2, 1.2], output: [0, 1, 0]},
    %{input: [5.7, 2.9, 4.2, 1.3], output: [0, 1, 0]},
    %{input: [6.2, 2.9, 4.3, 1.3], output: [0, 1, 0]},
    %{input: [5.1, 2.5, 3.0, 1.1], output: [0, 1, 0]},
    %{input: [5.7, 2.8, 4.1, 1.3], output: [0, 1, 0]},
    %{input: [6.3, 3.3, 6.0, 2.5], output: [0, 0, 1]},
    %{input: [5.8, 2.7, 5.1, 1.9], output: [0, 0, 1]},
    %{input: [7.1, 3.0, 5.9, 2.1], output: [0, 0, 1]},
    %{input: [6.3, 2.9, 5.6, 1.8], output: [0, 0, 1]},
    %{input: [6.5, 3.0, 5.8, 2.2], output: [0, 0, 1]},
    %{input: [7.6, 3.0, 6.6, 2.1], output: [0, 0, 1]},
    %{input: [4.9, 2.5, 4.5, 1.7], output: [0, 0, 1]},
    %{input: [7.3, 2.9, 6.3, 1.8], output: [0, 0, 1]},
    %{input: [6.7, 2.5, 5.8, 1.8], output: [0, 0, 1]},
    %{input: [7.2, 3.6, 6.1, 2.5], output: [0, 0, 1]},
    %{input: [6.5, 3.2, 5.1, 2.0], output: [0, 0, 1]},
    %{input: [6.4, 2.7, 5.3, 1.9], output: [0, 0, 1]},
    %{input: [6.8, 3.0, 5.5, 2.1], output: [0, 0, 1]},
    %{input: [5.7, 2.5, 5.0, 2.0], output: [0, 0, 1]},
    %{input: [5.8, 2.8, 5.1, 2.4], output: [0, 0, 1]},
    %{input: [6.4, 3.2, 5.3, 2.3], output: [0, 0, 1]},
    %{input: [6.5, 3.0, 5.5, 1.8], output: [0, 0, 1]},
    %{input: [7.7, 3.8, 6.7, 2.2], output: [0, 0, 1]},
    %{input: [7.7, 2.6, 6.9, 2.3], output: [0, 0, 1]},
    %{input: [6.0, 2.2, 5.0, 1.5], output: [0, 0, 1]},
    %{input: [6.9, 3.2, 5.7, 2.3], output: [0, 0, 1]},
    %{input: [5.6, 2.8, 4.9, 2.0], output: [0, 0, 1]},
    %{input: [7.7, 2.8, 6.7, 2.0], output: [0, 0, 1]},
    %{input: [6.3, 2.7, 4.9, 1.8], output: [0, 0, 1]},
    %{input: [6.7, 3.3, 5.7, 2.1], output: [0, 0, 1]},
    %{input: [7.2, 3.2, 6.0, 1.8], output: [0, 0, 1]},
    %{input: [6.2, 2.8, 4.8, 1.8], output: [0, 0, 1]},
    %{input: [6.1, 3.0, 4.9, 1.8], output: [0, 0, 1]},
    %{input: [6.4, 2.8, 5.6, 2.1], output: [0, 0, 1]},
    %{input: [7.2, 3.0, 5.8, 1.6], output: [0, 0, 1]},
    %{input: [7.4, 2.8, 6.1, 1.9], output: [0, 0, 1]},
    %{input: [7.9, 3.8, 6.4, 2.0], output: [0, 0, 1]},
    %{input: [6.4, 2.8, 5.6, 2.2], output: [0, 0, 1]},
    %{input: [6.3, 2.8, 5.1, 1.5], output: [0, 0, 1]},
    %{input: [6.1, 2.6, 5.6, 1.4], output: [0, 0, 1]},
    %{input: [7.7, 3.0, 6.1, 2.3], output: [0, 0, 1]},
    %{input: [6.3, 3.4, 5.6, 2.4], output: [0, 0, 1]},
    %{input: [6.4, 3.1, 5.5, 1.8], output: [0, 0, 1]},
    %{input: [6.0, 3.0, 4.8, 1.8], output: [0, 0, 1]},
    %{input: [6.9, 3.1, 5.4, 2.1], output: [0, 0, 1]},
    %{input: [6.7, 3.1, 5.6, 2.4], output: [0, 0, 1]},
    %{input: [6.9, 3.1, 5.1, 2.3], output: [0, 0, 1]},
    %{input: [5.8, 2.7, 5.1, 1.9], output: [0, 0, 1]},
    %{input: [6.8, 3.2, 5.9, 2.3], output: [0, 0, 1]},
    %{input: [6.7, 3.3, 5.7, 2.5], output: [0, 0, 1]},
    %{input: [6.7, 3.0, 5.2, 2.3], output: [0, 0, 1]},
    %{input: [6.3, 2.5, 5.0, 1.9], output: [0, 0, 1]},
    %{input: [6.5, 3.0, 5.2, 2.0], output: [0, 0, 1]},
    %{input: [6.2, 3.4, 5.4, 2.3], output: [0, 0, 1]},
    %{input: [5.9, 3.0, 5.1, 1.8], output: [0, 0, 1]}
  ]

  def or_gate, do: @or_gate
  def and_gate, do: @and_gate
  def xor_gate, do: @xor_gate
  def nand_gate, do: @nand_gate
  def iris_flower_gate, do: @iris_flower
end

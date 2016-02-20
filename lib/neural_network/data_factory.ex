defmodule NeuralNetwork.DataFactory do
  @or_gate [
    %{input: [0,0], output: [0]},
    %{input: [0,1], output: [1]},
    %{input: [1,0], output: [1]},
    %{input: [1,1], output: [1]}
  ]

  def or_gate do
    @or_gate
  end
end

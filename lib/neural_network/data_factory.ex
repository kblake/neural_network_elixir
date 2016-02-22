defmodule NeuralNetwork.DataFactory do
  @or_gate [
    %{input: [0,0], output: [0]},
    %{input: [0,1], output: [1]},
    %{input: [1,0], output: [1]},
    %{input: [1,1], output: [1]}
  ]

  @and_gate [
    %{input: [0,0], output: [0]},
    %{input: [0,1], output: [0]},
    %{input: [1,0], output: [0]},
    %{input: [1,1], output: [1]}
  ]

  @xor_gate [
    %{input: [0,0], output: [0]},
    %{input: [0,1], output: [1]},
    %{input: [1,0], output: [1]},
    %{input: [1,1], output: [0]}
  ]

  @nand_gate [
    %{input: [0,0], output: [1]},
    %{input: [0,1], output: [1]},
    %{input: [1,0], output: [1]},
    %{input: [1,1], output: [0]}
  ]

  def or_gate do
    @or_gate
  end

  def and_gate do
    @and_gate
  end

  def xor_gate do
    @xor_gate
  end

  def nand_gate do
    @nand_gate
  end

  def gate_for(name) do
    {:ok, data} = Map.fetch(gates, String.to_atom(name))
    data
  end

  def gates do
    %{
      or:   or_gate,
      and:  and_gate,
      xor:  xor_gate,
      nand: nand_gate
    }
  end

  def gate_names do
    gates |> Map.keys |> Enum.join(", ")
  end

  def gate_exists?(name) do
    Map.has_key? gates, String.to_atom(name)
  end

  def all do
    Map.values gates
  end
end

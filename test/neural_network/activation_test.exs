defmodule NeuralNetwork.ActivationTest do
  use ExUnit.Case
  doctest NeuralNetwork.Activation

  alias NeuralNetwork.{Activation}

  test ".activation_function sigmoid" do
    assert Activation.calculate_output(1, :sigmoid) == 0.7310585786300049
  end

  test ".activation_function relu" do
    assert Activation.calculate_output(1, :relu) == 1
    assert Activation.calculate_output(-1, :relu) == 0
  end

  test ".activation_function softmax" do
    assert Activation.calculate_output([1,2,3], :softmax) == [0.09003057317038046, 0.24472847105479764, 0.6652409557748218]
  end
end

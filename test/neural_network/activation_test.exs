defmodule NeuralNetwork.ActivationTest do
  use ExUnit.Case
  doctest NeuralNetwork.Activation

  alias NeuralNetwork.{Activation}

  test ".activation_function sigmoid" do
    assert Activation.calculate_output(:sigmoid, 1) == 0.7310585786300049
  end

  test ".activation_function relu" do
    assert Activation.calculate_output(:relu, 1) == 1
    assert Activation.calculate_output(:relu, -1) == 0
  end

  test ".activation_function softmax" do
    assert Activation.calculate_output(:softmax, [1,2,3]) == [0.09003057317038046, 0.24472847105479764, 0.6652409557748218]
  end

  test ".activation_function identity" do
    assert Activation.calculate_output(:identity, 100) == 100
  end

  test ".activation_function tanh" do
    assert Activation.calculate_output(:tanh, 3) == 0.9950547536867305
  end
end

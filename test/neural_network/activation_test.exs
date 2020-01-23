defmodule NeuralNetwork.ActivationTest do
  use ExUnit.Case
  doctest NeuralNetwork.Activation

  alias NeuralNetwork.{Activation}

  test ".activation_function sigmoid" do
    assert Activation.calculate_output(1, :sigmoid) == 0.7310585786300049
  end
end

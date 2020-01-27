defmodule NeuralNetwork.ThinkerTest do
  use ExUnit.Case
  doctest NeuralNetwork.Thinker

  alias NeuralNetwork.{Thinker, Network, Trainer, DataFactory}

  test "Predict return for gate AND" do
    {:ok, pid} = Network.start_link([2, 1], %{activation: :relu})

    data = DataFactory.gate_for("and")

    pid
    |> Trainer.train(data, %{epochs: 10_000, log_freqs: 1000})

    assert List.first(Thinker.predict(pid, [0,0])) < 0.09
    assert List.first(Thinker.predict(pid, [0,1])) < 0.09
    assert List.first(Thinker.predict(pid, [1,0])) < 0.09
    assert List.first(Thinker.predict(pid, [1,1])) > 0.99
  end
end

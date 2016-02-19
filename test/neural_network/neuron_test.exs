defmodule NeuralNetwork.NeuronTest do
  alias NeuralNetwork.{Neuron, Connection}
  use ExUnit.Case
  doctest Neuron

  test "has default values as an agent" do
    neuron = Neuron.start_link
    assert neuron.input     == 0
    assert neuron.output    == 0
    assert neuron.incoming  == []
    assert neuron.outgoing  == []
    assert neuron.bias?     == false
    assert neuron.delta     == 0
  end

  test "has values passed in as an agent" do
    neuron = Neuron.start_link(%{input: 1, output: 2, incoming: [1], outgoing: [2], bias?: true, delta: 1})
    assert neuron.input     == 1
    assert neuron.output    == 2
    assert neuron.incoming  == [1]
    assert neuron.outgoing  == [2]
    assert neuron.bias?     == true
    assert neuron.delta     == 1
  end

  test "has learning rate" do
    assert Neuron.learning_rate == 0.3
  end

  test "update neuron values" do
    neuron = Neuron.start_link
    neuron = Neuron.update(neuron.pid, %{input: 1, output: 2, incoming: [1], outgoing: [2], bias?: true, delta: 1})
    assert neuron.input     == 1
    assert neuron.output    == 2
    assert neuron.incoming  == [1]
    assert neuron.outgoing  == [2]
    assert neuron.bias?     == true
    assert neuron.delta     == 1
  end

  test "bias neuron" do
    bias_neuron = Neuron.start_link(%{bias?: true})
    assert bias_neuron.bias?
    assert bias_neuron.incoming == []
    assert bias_neuron.outgoing == []
  end

  test ".connect" do
    neuronA = Neuron.start_link
    neuronB = Neuron.start_link

    {:ok, neuronA, neuronB} = Neuron.connect(neuronA, neuronB)

    assert length(neuronA.outgoing) == 1
    assert length(neuronB.incoming) == 1
  end

  test ".activation_function" do
    assert Neuron.activation_function(1) == 0.7310585786300049
  end

  test ".activate with specified value" do
    neuron = Neuron.start_link
    neuron = neuron |> Neuron.activate(1)
    assert neuron.output == 0.7310585786300049
  end

  test ".activate with no incoming connections" do
    neuron = Neuron.start_link
    neuron = neuron |> Neuron.activate
    assert neuron.output == 0.5
  end

  test ".activate with incoming connections" do
    neuronX = Neuron.start_link(%{output: 2})
    neuronY = Neuron.start_link(%{output: 5})

    connection_one = Connection.start_link(%{source_pid: neuronX.pid})
    connection_two = Connection.start_link(%{source_pid: neuronY.pid})

    neuronA = Neuron.start_link(%{incoming: [connection_one, connection_two]})
    neuron = neuronA |> Neuron.activate
    assert neuron.output == 0.9426758241011313
  end

  test ".activate a bias neuron" do
    neuron = Neuron.start_link(%{bias?: true})
    neuron = neuron |> Neuron.activate
    assert neuron.output == 1
  end

  test "connect and activate two neurons" do
    neuronA = Neuron.start_link
    neuronB = Neuron.start_link
    {:ok, neuronA, neuronB} = Neuron.connect(neuronA, neuronB)

    neuronA = Neuron.activate(neuronA, 2)
    neuronB = Neuron.activate(neuronB)

    assert neuronA.input  == 2
    assert neuronA.output == 0.8807970779778823
    assert neuronB.input  == 0.3523188311911529
    assert neuronB.output == 0.5871797762705651
  end

  test "train: delta should get smaller (learnin yo!)" do
    neuronA = Neuron.start_link
    neuronB = Neuron.start_link
    {:ok, neuronA, neuronB} = Neuron.connect(neuronA, neuronB)

    arbitrary_old_delta = 1000

    for n <- 1..100 do
      neuronA = neuronA |> Neuron.activate(2)
      neuronB = neuronB |> Neuron.activate

      neuronB = neuronB |> Neuron.train(1)
      neuronA |> Neuron.train

      # neuronB delta should be smaller than the previous one
      assert neuronB.delta < arbitrary_old_delta

      arbitrary_old_delta = neuronB.delta
    end
  end
end

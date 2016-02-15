defmodule NeuralNetwork.NeuronTest do
  alias NeuralNetwork.{Neuron, Connection}
  use ExUnit.Case
  doctest Neuron

  test "has default values" do
    neuron = %Neuron{}
    assert neuron.name      == ""
    assert neuron.input     == 0
    assert neuron.output    == 0
    assert neuron.incoming  == []
    assert neuron.outgoing  == []
    assert neuron.bias?     == false
    assert neuron.error     == 0
    assert neuron.delta     == 0
  end

  test "has default values as an agent" do
    Neuron.start_link(%{name: :one})
    neuron = Neuron.get(:one)
    assert neuron.name      == :one
    assert neuron.input     == 0
    assert neuron.output    == 0
    assert neuron.incoming  == []
    assert neuron.outgoing  == []
    assert neuron.bias?     == false
    assert neuron.error     == 0
    assert neuron.delta     == 0
  end

  test "has values passed in as an agent" do
    Neuron.start_link(%{name: :one, input: 1, output: 2, incoming: [1], outgoing: [2], bias?: true, error: 1, delta: 1})
    neuron = Neuron.get(:one)
    assert neuron.name      == :one
    assert neuron.input     == 1
    assert neuron.output    == 2
    assert neuron.incoming  == [1]
    assert neuron.outgoing  == [2]
    assert neuron.bias?     == true
    assert neuron.error     == 1
    assert neuron.delta     == 1
  end

  test "has learning rate" do
    assert Neuron.learning_rate == 0.3
  end

  test "update neuron values" do
    Neuron.start_link(%{name: :n})
    Neuron.update(:n, %{input: 1, output: 2, incoming: [1], outgoing: [2], bias?: true, error: 1, delta: 1})
    neuron = Neuron.get(:n)
    assert neuron.input     == 1
    assert neuron.output    == 2
    assert neuron.incoming  == [1]
    assert neuron.outgoing  == [2]
    assert neuron.bias?     == true
    assert neuron.error     == 1
    assert neuron.delta     == 1
  end

  test "bias neuron" do
    Neuron.start_link(%{name: :b, bias?: true})
    bias_neuron = Neuron.get(:b)
    assert bias_neuron.bias?
    assert bias_neuron.incoming == []
    assert bias_neuron.outgoing == []
  end

  test ".connect" do
    Neuron.start_link(%{name: :a})
    Neuron.start_link(%{name: :b})
    neuronA = Neuron.get(:a)
    neuronB = Neuron.get(:b)

    {:ok, neuronA, neuronB} = Neuron.connect(neuronA, neuronB)

    assert length(neuronA.outgoing) == 1
    assert length(neuronB.incoming) == 1
  end

  test ".activation_function" do
    assert Neuron.activation_function(1) == 0.7310585786300049
  end

  test ".activate with specified value" do
    Neuron.start_link(%{name: :a})
    neuron = Neuron.get(:a) |> Neuron.activate(1)
    assert neuron.output == 0.7310585786300049
  end

  test ".activate with no incoming connections" do
    Neuron.start_link(%{name: :a})
    neuron = Neuron.get(:a) |> Neuron.activate
    assert neuron.output == 0.5
  end

  test ".activate with incoming connections" do
    Neuron.start_link(%{name: :x, output: 2})
    neuronX = Neuron.get(:x)
    Neuron.start_link(%{name: :y, output: 5})
    neuronY = Neuron.get(:y)

    Connection.start_link(%{name: :one, source_name: neuronX.name})
    connection_one = Connection.get(:one)

    Connection.start_link(%{name: :two, source_name: neuronY.name})
    connection_two = Connection.get(:two)

    Neuron.start_link(%{
            name: :a,
            incoming: [connection_one, connection_two]})
    neuron = Neuron.get(:a) |> Neuron.activate
    assert neuron.output == 0.9426758241011313
  end

  test ".activate a bias neuron" do
    Neuron.start_link(%{name: :a, bias?: true})
    neuron = Neuron.get(:a) |> Neuron.activate
    assert neuron.output == 1
  end

  test "connect and activate two neurons" do
    Neuron.start_link(%{name: :a})
    Neuron.start_link(%{name: :b})
    neuronA = Neuron.get((:a))
    neuronB = Neuron.get((:b))

    {:ok, neuronA, neuronB} = Neuron.connect(neuronA, neuronB)

    neuronA = Neuron.activate(neuronA, 2)
    neuronB = Neuron.activate(neuronB)

    assert neuronA.input  == 2
    assert neuronA.output == 0.8807970779778823
    assert neuronB.input  == 0.3523188311911529
    assert neuronB.output == 0.5871797762705651
  end

  test "train: error rate should get smaller (learnin yo!)" do
    Neuron.start_link(%{name: :a})
    Neuron.start_link(%{name: :b})
    neuronA = Neuron.get((:a))
    neuronB = Neuron.get((:b))
    {:ok, neuronA, neuronB} = Neuron.connect(neuronA, neuronB)

    arbitrary_old_error = 1000

    for n <- 1..100 do
      neuronA = neuronA |> Neuron.activate(2)
      neuronB = neuronB |> Neuron.activate

      neuronB = neuronB |> Neuron.train(1)
      neuronA |> Neuron.train

      assert neuronB.error < arbitrary_old_error

      arbitrary_old_error = neuronB.error
    end
  end
end

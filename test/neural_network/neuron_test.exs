defmodule NeuralNetwork.NeuronTest do
  alias NeuralNetwork.{Connection, Neuron}
  use ExUnit.Case
  doctest Neuron

  test "has default values as an agent" do
    {:ok, pid} = Neuron.start_link()
    neuron = Neuron.get(pid)

    assert neuron.input == 0
    assert neuron.output == 0
    assert neuron.incoming == []
    assert neuron.outgoing == []
    assert neuron.bias? == false
    assert neuron.delta == 0
  end

  test "has values passed in as an agent" do
    {:ok, pid} =
      Neuron.start_link(%{
        input: 1,
        output: 2,
        incoming: [1],
        outgoing: [2],
        bias?: true,
        delta: 1
      })

    neuron = Neuron.get(pid)
    assert neuron.input == 1
    assert neuron.output == 2
    assert neuron.incoming == [1]
    assert neuron.outgoing == [2]
    assert neuron.bias? == true
    assert neuron.delta == 1
  end

  test "has learning rate" do
    assert Neuron.learning_rate() == 0.3
  end

  test "update neuron values" do
    {:ok, pid} = Neuron.start_link()

    Neuron.update(pid, %{input: 1, output: 2, incoming: [1], outgoing: [2], bias?: true, delta: 1})

    neuron = Neuron.get(pid)
    assert neuron.input == 1
    assert neuron.output == 2
    assert neuron.incoming == [1]
    assert neuron.outgoing == [2]
    assert neuron.bias? == true
    assert neuron.delta == 1
  end

  test "bias neuron" do
    {:ok, pid} = Neuron.start_link(%{bias?: true})
    bias_neuron = Neuron.get(pid)
    assert bias_neuron.bias?
    assert bias_neuron.incoming == []
    assert bias_neuron.outgoing == []
  end

  test ".connect" do
    {:ok, pid_a} = Neuron.start_link()
    {:ok, pid_b} = Neuron.start_link()

    Neuron.connect(pid_a, pid_b)

    assert length(Neuron.get(pid_a).outgoing) == 1
    assert length(Neuron.get(pid_b).incoming) == 1
  end

  test ".activation_function" do
    assert Neuron.activation_function(1) == 0.7310585786300049
  end

  test ".activate with specified value" do
    {:ok, pid} = Neuron.start_link()
    pid |> Neuron.activate(:sigmoid, 1)
    assert Neuron.get(pid).output == 0.7310585786300049
  end

  test ".activate with no incoming connections" do
    {:ok, pid} = Neuron.start_link()
    pid |> Neuron.activate(:sigmoid)
    assert Neuron.get(pid).output == 0.5
  end

  test ".activate with incoming connections" do
    {:ok, pid_x} = Neuron.start_link(%{output: 2})
    {:ok, pid_y} = Neuron.start_link(%{output: 5})

    {:ok, connection_one_pid} = Connection.start_link(%{source_pid: pid_x})
    {:ok, connection_two_pid} = Connection.start_link(%{source_pid: pid_y})

    {:ok, pid_a} = Neuron.start_link(%{incoming: [connection_one_pid, connection_two_pid]})
    pid_a |> Neuron.activate(:sigmoid)
    assert Neuron.get(pid_a).output == 0.9426758241011313
  end

  test ".activate a bias neuron" do
    {:ok, pid} = Neuron.start_link(%{bias?: true})
    pid |> Neuron.activate(:sigmoid)
    assert Neuron.get(pid).output == 1
  end

  test "connect and activate two neurons" do
    {:ok, pid_a} = Neuron.start_link()
    {:ok, pid_b} = Neuron.start_link()
    Neuron.connect(pid_a, pid_b)

    pid_a |> Neuron.activate(:sigmoid, 2)
    pid_b |> Neuron.activate(:sigmoid)

    neuron_a = Neuron.get(pid_a)
    neuron_b = Neuron.get(pid_b)

    assert neuron_a.input == 2
    assert neuron_a.output == 0.8807970779778823
    assert neuron_b.input == 0.3523188311911529
    assert neuron_b.output == 0.5871797762705651
  end

  test "train: delta should get smaller (learnin yo!)" do
    {:ok, pid_a} = Neuron.start_link()
    {:ok, pid_b} = Neuron.start_link()
    Neuron.connect(pid_a, pid_b)

    deltas =
      Enum.map(1..100, fn _ ->
        pid_a |> Neuron.activate(:sigmoid, 2)
        pid_b |> Neuron.activate(:sigmoid)

        pid_b |> Neuron.train(1)
        pid_a |> Neuron.train()

        Neuron.get(pid_b).delta
      end)

    deltas
    |> Stream.with_index()
    |> Enum.each(fn tuple ->
      {delta, index} = tuple

      if Enum.at(deltas, index + 1) do
        assert delta < Enum.at(deltas, index + 1)
      end
    end)
  end
end

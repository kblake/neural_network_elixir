@moduledoc """
Mixfile to define project dependencies
"""
defmodule NeuralNetwork.Mixfile do
  use Mix.Project

  def project do
    [
      app: :neural_network,
      version: "0.2.0",
      elixir: "~> 1.8",
      name: "Neural Network",
      description: description(),
      package: package(),
      source_url: "https://github.com/kblake/neural_network_elixir",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger], mod: {NeuralNetwork, []}]
  end

  defp description do
    """
    A neural network made up of layers of neurons connected to each other to form a relationship allowing it to learn.
    """
  end

  defp package do
    [
      maintainers: ["Karmen Blake"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/kblake/neural_network_elixir"
      }
    ]
  end

  defp deps do
    [
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:mix_test_watch, "~> 0.9", only: :dev},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false}
    ]
  end
end

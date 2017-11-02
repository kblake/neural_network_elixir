defmodule NeuralNetwork.Mixfile do
  use Mix.Project

  def project do
    [app: :neural_network,
     version: "0.1.3",
     elixir: "~> 1.2",
     name: "Neural Network",
     description: description(),
     package: package(),
     source_url: "https://github.com/kblake/neural_network_elixir",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger],
     mod: {NeuralNetwork, []}]
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
      {:earmark, "~> 1.0.2", only: :dev},
      {:ex_doc, "~> 0.14.3", only: :dev},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end

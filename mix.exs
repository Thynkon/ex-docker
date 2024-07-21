defmodule ExDocker.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.trim()

  def project do
    [
      app: :ex_docker,
      version: @version,
      elixir: "~> 1.6",
      deps: deps(),

      # Hex
      description: description(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:jason, ">= 1.0.0"},
      {:tesla, git: "https://github.com/Thynkon/tesla"},
      {:mint, "~> 1.0"},
      {:castore, "~> 0.1"},
      {:earmark, "~> 1.4", only: :dev},
      {:ex_doc, "~> 0.25", only: :dev},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Elixir client for the Docker Remote API.
    """
  end

  defp package do
    [
      contributors: ["William Huba"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/hexedpackets/docker-elixir"},
      files: ~w(mix.exs README.md LICENSE VERSION config lib)
    ]
  end
end

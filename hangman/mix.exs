defmodule Hangman.MixProject do
  use Mix.Project

  def project do
    [
      app: :hangman,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end

  def application do
    [
      mod: { Hangman.Runtime.Application, [] },
      extra_applications: [:logger, :observer, :wx, :runtime_tools]
    ]
  end

  defp deps do
    [
      { :dialyxir, "~> 1.0", only: [:dev], runtime: false },
      { :dictionary, path: "../dictionary" }
    ]
  end
end

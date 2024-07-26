defmodule TextClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :text_client,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :observer, :wx, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:hangman, path: "../hangman"},
    ]
  end
end

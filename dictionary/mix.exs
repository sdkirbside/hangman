defmodule Dictionary.MixProject do
  use Mix.Project

  def project do
    [
      app: :dictionary,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: { Dictionary.Runtime.Application, [] },
      extra_applications: [:logger, :observer, :wx, :runtime_tools]
    ]
  end

  defp deps, do: []
end

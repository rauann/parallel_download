defmodule ParallelDownload.MixProject do
  use Mix.Project

  def project do
    [
      app: :parallel_download,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:valid_url, "~> 0.1.2"}
    ]
  end
end
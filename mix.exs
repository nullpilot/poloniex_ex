defmodule Poloniex.Mixfile do
  use Mix.Project

  def project do
    [app: :poloniex,
     version: "0.1.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison, :vex, :exconstructor]]
  end

  defp deps do
    [
      {:poison, "~> 2.0"},
      {:httpoison, "~> 0.10"},
      {:credo, "~> 0.5", only: [:test,:dev]},
      {:ex_doc, ">= 0.0.0", only: [:dev]},
      {:exconstructor, ">= 1.0.0"},
      {:vex, ">= 0.0.0"}
    ]
  end


    defp description do
      """
      WIP, not stable
      Elixir API wrapper for poloniex.com. Provides access to market data including trading pairs between ETH, BTC, DOGE, LTC and others.
      """
    end

    defp package do
      [# These are the default files included in the package
       files: ["lib", "mix.exs", "LICENSE*"],
       maintainers: ["ontofractal"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/cyberpunk-ventures/poloniex_ex"}]
     end


end


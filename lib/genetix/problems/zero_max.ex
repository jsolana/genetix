defmodule Genetix.Problems.ZeroMax do
  @moduledoc """
  A specific genetic problem implementation for ZeroMax.
  The Zero-Max problem is a trivial problem: What is the minimum sum of a bitstring (a string consisting of only 1s and 0s) of length N.

  Hyperparameters

    - `size` length of the bitestring (0s, 1s). Default `42`.
    - `sort_criteria` due its a minimal optimization problem, we need to override the defaul value based on max, with the `&<=2` operator.

  ## Examples

      iex> Genetix.Evolution.run(Genetix.Problems.ZeroMax, size: 1000, sort_criteria: &<=/2)

  """
  @behaviour Genetix.Problem
  alias Genetix.Types.Chromosome

  @impl true
  @doc """
  Genotype implementation for ZeroMax problem. Bitstring
  """
  def genotype(opts \\ []) do
    size = Keyword.get(opts, :size, 42)
    genes = for _ <- 1..size, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: size}
  end

  @impl true
  @doc """
  fitness function implementation for ZeroMax problem.
  """
  def fitness_function(chromosome, _opts \\ []), do: Enum.sum(chromosome.genes)

  @impl true
  @doc """
  Terminate function implementation for ZeroMax problem.
  """
  def terminate?([best | _], _generation, _opts \\ []) do
    IO.write("\r#{inspect(best.fitness)}")
    best.fitness < 1
  end
end

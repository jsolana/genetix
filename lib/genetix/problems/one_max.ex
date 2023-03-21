defmodule Genetix.Problems.OneMax do
  @moduledoc """
  A specific genetic problem implementation for OneMax.
  The One-Max problem is a trivial problem: What is the maximum sum of a bitstring (a string consisting of only 1s and 0s) of length N.

  Hyperparameters

    - `size` length of the bitestring (0s, 1s). Default `42`.

  ## Examples

      iex> Genetix.Evolution.run(Genetix.Problems.OneMax, size: 1000)

  """
  @behaviour Genetix.Problem
  alias Genetix.Types.Chromosome

  @impl true
  @doc """
  Genotype implementation for OneMax problem. Bitstring.
  """
  def genotype(opts \\ []) do
    size = Keyword.get(opts, :size, 42)
    genes = for _ <- 1..size, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: size}
  end

  @impl true
  @doc """
  Fitness function implementation for OneMax problem.
  """
  def fitness_function(chromosome, _opts \\ []), do: Enum.sum(chromosome.genes)

  @impl true
  @doc """
  Terminate implementation for OneMax problem.
  """
  def terminate?([best | _], _opts \\ []) do
    IO.write("\r#{inspect(best.fitness)}")
    best.fitness == best.size
  end
end

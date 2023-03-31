defmodule Genetix.Problems.Speller do
  @moduledoc """
  A specific problem implementation to obtain @target (a-z no whitespaces) string.

  Hyperparameters

    - `target` an a-z no whitespaces string. By default `elixir`.
    - `max_generation`, termination criteria. By default `10_000`.

  ## Examples

      iex> Genetix.Evolution.run(Genetix.Problems.Speller, target: "elixir", max_generation: 1)

  """
  @behaviour Genetix.Problem
  alias Genetix.Types.Chromosome

  @default_target "elixir"
  @impl true
  @doc """
  Genotype implementation for Speller problem. Permutation
  """
  def genotype(opts \\ []) do
    target = Keyword.get(opts, :target, @default_target)
    size = String.length(target)

    genes =
      Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(size)

    %Chromosome{genes: genes, size: size}
  end

  @impl true
  @doc """
  Fitness function implementation for Speller problem.
  """
  def fitness_function(chromosome, opts \\ []) do
    target = Keyword.get(opts, :target, @default_target)
    guess = List.to_string(chromosome.genes)
    String.jaro_distance(target, guess)
  end

  @impl true
  @doc """
  Terminate implementation for Speller problem.
  """
  def terminate?([best | _], generation, opts \\ []) do
    max_generation = Keyword.get(opts, :max_generation, 10_000)
    fit_str = best.fitness |> :erlang.float_to_binary(decimals: 4)
    IO.write("\r#{fit_str}")
    best.fitness == 1 || generation == max_generation
  end
end

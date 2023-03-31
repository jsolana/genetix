defmodule Genetix do
  @moduledoc """
  Structure of a genetic algorithm in Elixir.

  The process of creating an algorithm can be thought of in three phases:
    1. Problem Definition
    2. Evolution Definition
    3. Algorithm Execution

  To define a `Problem`  you need to define the specific-problems funtions:
    1. Define your solution space (`genotype/1`): How to generate a new individual of your problem.
    2. Define your objective function (`fitness_function/2`): How to evaluate each individual.
    3. Define your termination criteria (`terminate?/2`): When the algorithm must to stop.

  ## Implementing a Problem
  A basic genetic  problem consists of: `genotype/0`, `fitness_function/1`, and `terminate?/1`.
  ```
  defmodule OneMax do
    @behaviour Genetix.Problem
    alias Genetix.Types.Chromosome

    @impl true
    def genotype(opts \\ []) do
      size = Keyword.get(opts, :size, 10)
      genes = for _ <- 1..42, do: Enum.random(0..1)
      %Chromosome{genes: genes, size: size}
    end

    @impl true
    def fitness_function(chromosome, _opts \\ []), do: Enum.sum(chromosome.genes)

    @impl true
    def terminate?([best | _], _opts \\ []) do
      best.fitness == best.size
    end
  end
  ```

  Notice that in this case, we use `size` as a hyperparameter to define the gene size.

  ## Hyperparameters

  It refers to the parts of the algotihm you set before the algorithm starts to configure the behavior of the algorithm: which GA operators use,
  size of the individuals, etc.. You can provide a `Keyword` with hyperparameters.

  Check [Problem definition](lib/genetics/problem.ex) for more information.

  ## Examples

      iex> alias Genetix.Problems.OneMax
      iex> Genetix.run(OneMax, size: 100)


  """
  alias Genetix.Evolution.{CrossOver, Mutation, Select, Evaluate, Reinsertion}

  require Logger

  @doc """
  Run a specific problem with optional `hyperparameters`.

  Check [Problem definition](lib/genetics/problem.ex) for more information about `hyperparameters`.
  """
  def run(problem, opts \\ []) do
    Logger.info("Running #{inspect(problem)}")
    # Logger.info("opts: #{inspect(opts)}")
    population = initialize(&problem.genotype/1, opts)

    population
    |> evolve(problem, opts)
  end

  defp initialize(genotype, opts) do
    population_size = Keyword.get(opts, :population_size, 100)
    population = for _ <- 1..population_size, do: genotype.(opts)
    # IO.gets("Population: #{inspect(population)}\nPress Enter to continue...")
    population
  end

  defp evolve(population, problem, opts) do
    population = evaluate(population, &problem.fitness_function/2, opts)
    best = hd(population)
    # IO.write("\rCurrent Best: #{fitness_function.(best)}")
    # IO.gets("Population evolved: #{inspect(population)}\nCurrent Best: #{inspect(best)}\nPress Enter to continue...")

    if problem.terminate?(population, opts) do
      IO.write("\r")
      best
    else
      {parents, leftover} = select(population, opts)
      children = crossover(parents, opts)
      mutants = mutation(children, opts)
      offspring = children ++ mutants
      new_population = reinsertion(parents, offspring, leftover, opts)
      evolve(new_population, problem, opts)
    end
  end

  defp evaluate(population, fitness_function, opts) do
    evaluate_operator = Keyword.get(opts, :evaluate_type, &Evaluate.heuristic_evaluation/3)
    result = evaluate_operator.(population, fitness_function, opts)
    # IO.gets("Evaluate result: #{inspect(result)}\nPress Enter to continue...")
    result
  end

  defp select(population, opts) do
    select_operator = Keyword.get(opts, :select_type, &Select.select_elite/3)
    select_rate = Keyword.get(opts, :select_rate, 0.8)

    n = round(length(population) * select_rate)
    n = if rem(n, 2) == 0, do: n, else: n + 1

    parents = select_operator.(population, n, opts)
    leftover = population |> MapSet.new() |> MapSet.difference(MapSet.new(parents))

    parents = parents |> Enum.chunk_every(2) |> Enum.map(&List.to_tuple(&1))
    result = {parents, MapSet.to_list(leftover)}
    # IO.gets("Select result: #{inspect(result)}\nPress Enter to continue...")
    result
  end

  defp crossover(population, opts) do
    crossover_operator = Keyword.get(opts, :crossover_type, &CrossOver.crossover_cx_one_point/3)

    result =
      population
      |> Enum.reduce(
        [],
        fn {p1, p2}, acc ->
          {c1, c2} = crossover_operator.(p1, p2, opts)
          [c1, c2 | acc]
        end
      )

    # IO.gets("Crossover result: #{inspect(result)}\nPress Enter to continue...")
    result
  end

  defp mutation(population, opts) do
    mutation_operator = Keyword.get(opts, :mutation_type, &Mutation.mutation_shuffle/2)
    mutation_probability = Keyword.get(opts, :mutation_probability, 0.05)
    n = floor(length(population) * mutation_probability)

    result =
      population
      |> Enum.take_random(n)
      |> Enum.map(fn chromosome ->
        mutation_operator.(chromosome, opts)
      end)

    # IO.gets("Mutation result: #{inspect(result)}\nPress Enter to continue...")
    result
  end

  def reinsertion(parents, offspring, leftover, opts \\ []) do
    reinsert_operator = Keyword.get(opts, :reinsert_type, &Reinsertion.pure/4)
    reinsert_operator.(parents, offspring, leftover, opts)
  end
end

defmodule Genetix.Evolution.Evaluate do
  @moduledoc """
  Contain functions with different aproaches to make the evaluation.
  Every problem has an objetive. The goal of optimization is to maximize or minimize a value.

  In genetic algorithms, fitness functions tell you how well you are. You use them as a barometer to measure
  your progress toward the best solution.

  """

  alias Genetix.Types.Chromosome

  require Logger

  @doc """
  Use `fitness_function` to evaluate every individual of the population and returns a list sorted by
  `sort_criteria` hyperparameter.

  A fitness function is a heuristic, an approximation or estimation based on limited information.

  """
  def heuristic_evaluation(population, fitness_function, opts \\ []) do
    sort_criteria = Keyword.get(opts, :sort_criteria, &>=/2)

    population
    |> Enum.map(fn chromosome ->
      fitness = fitness_function.(chromosome, opts)
      age = chromosome.age + 1

      # IO.gets("Fitness function for #{inspect(chromosome)}\nResult: #{inspect(fitness)}\nPress Enter to continue...")

      %Chromosome{chromosome | fitness: fitness, age: age}
    end)
    |> Enum.sort_by(& &1.fitness, sort_criteria)
  end
end

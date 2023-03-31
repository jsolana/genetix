defmodule Genetix.Problem do
  @moduledoc """
  Genetic problem behaviour definition with the problem-specific functions that a problem must to provide:
    - Fitness function: How to evaluate the individual. It gives a fitness score of the individual.
    - Genotype: How to create a new individual.
    - Termination criteria: When the algorithm must to stop.

    These functions allow `hyperparameters` to allow controls how the algorithm works as population size, mutation rate.
    Each Problem implementation can define and document its hyperparameters.

    Common `hyperparameters`:

    - `evaluation_type`:      Evaluation operator. By default `heuristic_evaluation/3`.
    - `select_type`:          Selection operator. By default `select_elite/3`.
    - `select_rate`:          Selection rate. By default `0.8`. Take care of growing and shrinking population in combination with `survive_rate`.
    - `crossover_type`:       Crossover operator. By defaul `crossover_cx_one_point/3`. To run successfully this problem, you need to override this property using `custom_crossover` function.
    - `crossover_rate`:       Crossover rate, apply in some strategies as `uniform` to determine the probability to swap both genes. By default `0.5` (50% of probability).
    - `mutation_type`:        Mutation operator. By default `mutation_shuffle/2`. To run successfully this problem, you need to override this property using `custom_mutation` function.
    - `mutation_probability`: Mutation probability. By defaul `0.05`.
    - `sort_criteria`:        How to sort the population by its fitness score (max or min). By default max first.
    - `reinsertion_type`:     Reinsertion strategy. By defaul `pure/4`.
    - `reinsertion_rate`:     Portion of old chromosomes to survive the next generation. By defaul `0.2`. Take care of growing and shrinking population in combination with `select_rate`.
    - `statistics`:           Map with statistic functions to apply.

    Optional `hyperparameters`:

    - `size`:                 Total number of locations. By default `10`.
    - `population_size`:      Total number of individuals to run the algorithm. By default `100`.

  """
  @typedoc """
  Hyperparameters type.
  Hyperparameters are represented as a `Keyword`. Are optional.
  Take a look to `Genetix.Problem`module documentation or specific Problem implementation to know the details of the `hyperparameters` supported.
  """
  @type hyperparameters :: keyword()
  alias Genetix.Types.Chromosome

  @doc """
  Generate a new individual.
  """
  @callback genotype(hyperparameters) :: Chromosome.t()

  @doc """
  The fitness function determines how fit an individual is (the ability of an individual to compete with other individuals).
  Returns: It gives a fitness score to each individual. The probability that an individual will be selected for reproduction is based on its fitness score.
  """
  @callback fitness_function(Chromosome.t(), hyperparameters) :: number()

  @doc """
  Its defines when the algorithm must to stop returning true or continue in other case.
  """
  @callback terminate?(Enum.t(), integer(), hyperparameters) :: boolean()
end

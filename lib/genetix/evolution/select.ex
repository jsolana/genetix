defmodule Genetix.Evolution.Select do
  @moduledoc """
  Contain functions with different aproaches / strategies to make the selection.
  Selection is the stage of a genetic algorithm or more general evolutionary algorithm in which individual
  genomes are chosen from a population for later breeding (e.g., using the crossover operator).

  [More info](https://en.wikipedia.org/wiki/Selection_(genetic_algorithm))

  """

  # alias Genetix.Types.Chromosome

  require Logger

  @doc """
  Often to get better parameters, strategies with partial reproduction are used.
  One of them is elitism, in which a small portion of the best individuals from the last generation is carried over (without any changes) to the next one.
  With Elitism selection, we chose the better `number_of_candidates` candidates (using its fitness_function).

  Take care because with this kind of selection we can have a lack of diversity
  """
  def select_elite(population, number_of_candidates, _opts \\ []) do
    population
    |> Enum.take(number_of_candidates)
  end

  @doc """
  Random selection pays no mind to chromosome's fitness and select a random  `number_of_candidates` candidates from the population.
  Take care because this strategy is uncommon but is very useful if you goal is to obtain a high genetic diversity.
  """
  def select_random(population, number_of_candidates, _opts \\ []) do
    population
    |> Enum.take_random(number_of_candidates)
  end

  @doc """
  Tournament selection is a strategy that pist chromosomes against one another in a tournament. While selections are
  still based on fitness, tounament selection introduces a strategy to choose parents that are both diverse and strong.

  In tournament selection, tournaments can be any n-way: the tournament size can be any nombre from 1 to the size of the population.
  The tournament size is defined by `tournament_size` hyperparameter.

  This implementation allows duplicates.

  Tournamente selection works like this:

    1) Choose a pool of n chromosomes where n is the `tournament_size`.
    2) Choose the fittest cohormosome from the tournament.
    3) Repeat.

    The beauty of tournament selection is the balance between genetic diversity and fitness.
    In this case we are using the max_by function

  """
  def select_tournament_max(population, number_of_candidates, opts \\ []) do
    tournament_size = Keyword.get(opts, :tournament_size, 3)

    0..number_of_candidates
    |> Enum.map(fn _ ->
      population |> Enum.take_random(tournament_size) |> Enum.max_by(& &1.fitness)
    end)
  end

  @doc """
  Tournament selection is a strategy that pist chromosomes against one another in a tournament. While selections are
  still based on fitness, tounament selection introduces a strategy to choose parents that are both diverse and strong.

  In tournament selection, tournaments can be any n-way: the tournament size can be any nombre from 1 to the size of the population.
  The tournament size is defined by `tournament_size` hyperparameter.

  This implementation allows duplicates.

  Tournamente selection works like this:

    1) Choose a pool of n chromosomes where n is the `tournament_size`.
    2) Choose the fittest cohormosome from the tournament.
    3) Repeat.

    The beauty of tournament selection is the balance between genetic diversity and fitness.
    In this case we are using the min_by function

  """
  def select_tournament_min(population, number_of_candidates, opts \\ []) do
    tournament_size = Keyword.get(opts, :tournament_size, 3)

    0..number_of_candidates
    |> Enum.map(fn _ ->
      population |> Enum.take_random(tournament_size) |> Enum.min_by(& &1.fitness)
    end)
  end

  @doc """
  Also known as fitness proportionale selection, chooses parents with a probability
  proportional to their fitness.
  """
  def roulette(population, number_of_candidates, _opts \\ []) do
    sum_fitness =
      population
      |> Enum.map(fn chromosome -> chromosome.fitness end)
      |> Enum.sum()

    0..(number_of_candidates - 1)
    |> Enum.map(fn _ ->
      u = :rand.uniform() * sum_fitness
      spin(population, u)
    end)
  end

  defp spin(chromosomes, u) do
    chromosomes
    |> Enum.reduce_while(
      0,
      fn chromosome, acc ->
        if chromosome.fitness + acc > u do
          {:halt, chromosome}
        else
          {:cont, chromosome.fitness + acc}
        end
      end
    )
  end
end

defmodule Genetix.Evolution.Reinsertion do
  @moduledoc """
  Contain functions with different aproaches / strategies to make the reinsertion.
  Reinsertion is the process to takin chromosomes produced from selection, crossover,
  and mutation and inserting them back into a population to move on the next generation.

  """

  require Logger

  @doc """
  Every chromosome in the old population is replaced with an offspring of the new population
  It is a type of `generational replacement`, creating an enterely new population so there is
  no overlap betweeen populations(technically, offspring directly replace parents).
  Pure reinsertion maintains none of the strenght  of the old population and instead relies
  on the ability of selection, crossover, and mutation to form a  strong population.

  Remember that is fast but you could potentially eliminate some of your stronger individuals
  in a population as a result.
  """
  def pure(_parents, offspring, _leftover, _opts \\ []), do: offspring

  @doc """
  You keep a top-portion of your old population to survive the next generation.
  You need to define a `survival_rate`to dictates the percentage of parent chromosomes
  that survives to the next generation, eg: with a population of 100 and a `survival_rate`
  of 0.2 (20%), you'd keep 20 of your parents.
  """
  def elitist(parents, offspring, leftover, opts \\ []) do
    old = parents ++ leftover
    survival_rate = Keyword.get(opts, :survival_rate, 0.2)
    n = floor(length(old) * survival_rate)
    survivors = old |> Enum.sort_by(& &1.fitness, &>=/2) |> Enum.take(n)
    offspring ++ survivors
  end

  @doc """
  Also called random replacement is a reinsertion strategy that select random chromosomes
  from the old population to survive to the next generation. The purpose is to keep as much as
  genetic diversity as possible (is not too common).
  You need to define a `survival_rate`to dictates the percentage of parent chromosomes
  that survives to the next generation, eg: with a population of 100 and a `survival_rate`
  of 0.2 (20%), you'd keep 20 of your parents.
  """
  def uniform(parents, offspring, leftover, opts \\ []) do
    old = parents ++ leftover
    survival_rate = Keyword.get(opts, :survival_rate, 0.2)
    n = floor(length(old) * survival_rate)
    survivors = old |> Enum.take_random(n)
    offspring ++ survivors
  end
end

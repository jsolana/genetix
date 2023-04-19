defmodule Genetix.Evolution.CrossOver do
  @moduledoc """
  Contain functions with different aproaches / strategies to make the crossover.
  In genetic algorithms and evolutionary computation, crossover, also called recombination,
  is a genetic operator used to combine the genetic information of two parents to generate new offspring.

  Possibles strategies:
    - Single-point
    - Order-one
    - Uniform
    - Whole arithmetic Recombination (TODO)

  [More information](https://en.wikipedia.org/wiki/Crossover_(genetic_algorithm))

  """
  alias Genetix.Types.Chromosome

  require Logger

  @spec crossover_cx_one_point(Chromosome.t(), Chromosome.t(), keyword()) ::
          {Chromosome.t(), Chromosome.t()}
  @doc """
  Single-point crossover is the most basic crossover strategy. It works like this:

    1) Choose a random number k between 0..n-1 where n is the length of the parten chromosomes. Works on blocks of genes.
    2) Split both parents at k to rpdocue four slices of genes.
    3) Swap the tails of each parent at k produce two new children.

  """
  def crossover_cx_one_point(parent_1, parent_2, _opts \\ []) do
    cx_point = :rand.uniform(length(parent_1.genes))

    {{h1, t1}, {h2, t2}} =
      {Enum.split(parent_1.genes, cx_point), Enum.split(parent_2.genes, cx_point)}

    {%Chromosome{parent_1 | genes: h1 ++ t2}, %Chromosome{parent_2 | genes: h2 ++ t1}}
  end

  @spec order_one_crossover(Chromosome.t(), Chromosome.t(), keyword()) ::
          {Chromosome.t(), Chromosome.t()}
  @doc """
  Order-one crossover, sometimes called "Davis order" crossover, is a crossover strategy on ordered list or permutations.
  Order-one is  part of a unique set of crossover strategies that will preserve the integrity of a permutation without
  the need for chromosome repair. It works like this:

    1) Select a random slice of genes from Parent 1.
    2) Remove the values from the slice of Parent 1 from Parent 2.
    3) Insert the slice from Parten 1 into the same position in Parent 2.
    4) Repeat with a random slice from Parten 2.

  """
  def order_one_crossover(parent_1, parent_2, _opts \\ []) do
    lim = Enum.count(parent_1.genes) - 1
    # Get random range​
    {i1, i2} =
      [:rand.uniform(lim), :rand.uniform(lim)]
      |> Enum.sort()
      |> List.to_tuple()

    # parent_2 contribution​
    slice1 = Enum.slice(parent_1.genes, i1..i2)
    slice1_set = MapSet.new(slice1)
    parent_2_contrib = Enum.reject(parent_2.genes, &MapSet.member?(slice1_set, &1))
    {head1, tail1} = Enum.split(parent_2_contrib, i1)

    # parent_1 contribution​
    slice2 = Enum.slice(parent_2.genes, i1..i2)
    slice2_set = MapSet.new(slice2)
    parent_1_contrib = Enum.reject(parent_1.genes, &MapSet.member?(slice2_set, &1))
    {head2, tail2} = Enum.split(parent_1_contrib, i1)

    # Make and return​
    {c1, c2} = {head1 ++ slice1 ++ tail1, head2 ++ slice2 ++ tail2}

    {%Chromosome{
       genes: c1,
       size: parent_1.size
     },
     %Chromosome{
       genes: c2,
       size: parent_2.size
     }}
  end

  @spec uniform(Chromosome.t(), Chromosome.t(), keyword()) ::
          {Chromosome.t(), Chromosome.t()}
  @doc """
  Genes in the parent chromosome are treated separately (individually).
  Uniform crossover works by paaring corresponding genes in a chromosome an swapping them according to a rate
  defined by the `crossover_rate` hyperparameter. By default `0.5` (50% or probability to swap both genes).
  """
  def uniform(parent_1, parent_2, opts \\ []) do
    rate = Keyword.get(opts, :crossover_rate, 0.5)

    {c1, c2} =
      parent_1.genes
      |> Enum.zip(parent_2.genes)
      |> Enum.map(fn {x, y} ->
        if :rand.uniform() < rate do
          {x, y}
        else
          {y, x}
        end
      end)
      |> Enum.unzip()

    {%Chromosome{parent_1 | genes: c1}, %Chromosome{parent_2 | genes: c2}}
  end
end

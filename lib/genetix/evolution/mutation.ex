defmodule Genetix.Evolution.Mutation do
  @moduledoc """
  Contains functions with different aproaches / strategies to make the mutation.
  Mutation is a genetic operator used to maintain genetic diversity of the chromosomes of
  a population of a genetic or, more generally, an evolutionary algorithm (EA). It is analogous to biological mutation.

  The idea is to generate a random change to some or all of the genes in a chromosome introducing genetic diversity into the
  population.

  Possibles strategies:

    - Shuffle / Scramble
    - Flip (TODO)
    - Gaussian (TODO)


  [More information](https://en.wikipedia.org/wiki/Mutation_(genetic_algorithm))

  """
  alias Genetix.Types.Chromosome

  require Logger

  @doc """
  Also known as scramble mutation. Shuffle all of the genes in a given chromosome to create a new one.
  While shuffling  maybe has no impact on the finess of a chromosome, it served to ensure some percentage
  of your population remained different from the rest.
  """
  def mutation_shuffle(chromosome, _opts \\ []) do
    %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
  end
end

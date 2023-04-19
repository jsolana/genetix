defmodule Genetix.Types.Chromosome do
  @moduledoc """
  Chromosome type definition that represents a single solution.
  A Chromosome represents one solution to the problem you are trying to solve.
  Solutions are encoded into a collection of genes. The Chromosome is then evaluated based on some criteria you define.

  Chromosomes must be defined as very "self-aware" containing all of the information necessary to repair and evaluate themselves.
  """

  @typedoc """
  Chromosome type.
  Chromosomes are represented as a `%Chromosome{}`. At a minimum a chromosome needs `:genes`.

  # Fields
    - `:genes`: `Enum` containing genotype representation.
    - `:id`: `string` unique id of chromosome.
    - `:size`: `non_neg_integer` representing size of chromosome.
    - `:age`: `non_neg_integer` representing age of chromosome.
    - `:fitness`: `number` representing fitness(es) of chromosome.
  """
  @type t :: %__MODULE__{
          genes: Enum.t(),
          id: String.t(),
          size: non_neg_integer(),
          age: non_neg_integer(),
          fitness: number()
        }

  @enforce_keys :genes
  defstruct [
    :genes,
    id: Base.encode16(:crypto.strong_rand_bytes(64)),
    size: 0,
    fitness: 0,
    age: 0
  ]
end

defmodule Genetix.Benchmark do
  @moduledoc """
  An example of benchmarking
  """
  alias Genetix.Problems.OneMax

  dummy_population = Genetix.initialize(&OneMax.genotype/1, population_size: 100)
  {dummy_selected_population, _} = Genetix.select(dummy_population, selection_rate: 1.0)
  Benchee.run(%{
    "initialize" => fn -> Genetix.initialize(&OneMax.genotype/1) end,
    "evaluate" => fn -> Genetix.evaluate(dummy_population, &OneMax.fitness_function/2) end,
    "select" =>  fn -> Genetix.select(dummy_population) end,
    "crossover" => fn -> Genetix.crossover(dummy_selected_population) end,
    "mutation" => fn -> Genetix.mutation(dummy_population) end,
    #"evolve" => fn -> Genetix.evolve(dummy_population, OneMax, 0) end
  },
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ]
  )

end

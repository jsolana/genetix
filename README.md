# Genetix

`Genetix` is a framework to solve problems using genetic algorithms in Elixir.

The process of creating an algorithm can be thought of in three phases:

1. Problem Definition
2. Evolution Definition
3. Algorithm Execution

You only need to define the `Genetix.Problem` and run it using `Genetix.run/2` function!

To define a new `Genetix.Problem`  you need to define the specific-problems funtions:

1. Define your solution space (`genotype/1`): How to generate a new individual of your problem.
2. Define your objective function (`fitness_function/2`): How to evaluate each individual.
3. Define your termination criteria (`terminate?/2`): When the algorithm must to stop.

Depends of the case, you may need define custom `hyperparameters`. Internally, `genetix` understand these:

Common `hyperparameters`:

- `evaluation_type`: Evaluation operator. By default `heuristic_evaluation/3`.
- `select_type`: Selection operator. By default `select_elite/3`.
- `select_rate`: Selection rate. By default `0.8`. Take care of growing and shrinking population in combination with `reinsertion_rate`.
- `crossover_type`: Crossover operator. By defaul `crossover_cx_one_point/3`. To run successfully this problem, you need to override this property using `custom_crossover` function.
- `crossover_rate`: Crossover rate, apply in some strategies as `uniform` to determine the probability to swap both genes. By default `0.5` (50% of probability).
- `mutation_type`: Mutation operator. By default `mutation_shuffle/2`. To run successfully this problem, you need to override this property using `custom_mutation` function.
- `mutation_probability`: Mutation probability. By defaul `0.05`.
- `sort_criteria`: How to sort the population by its fitness score (max or min). By default max first.
- `reinsertion_type`: Reinsertion strategy. By defaul `pure/4`.
- `reinsertion_rate`: Portion of old chromosomes to survive the next generation. By defaul `0.2`. Take care of growing and shrinking population in combination with `select_rate`.
- `statistics`: Map name-function with statistic functions to apply. By default, it calculates the minimum, maximum an the mean of the population (based on the fitness score).

Optional `hyperparameters`:

- `size`: Total number of locations. By default `10`.
- `population_size`: Total number of individuals to run the algorithm. By default `100`.

To learn more and get started, check out [our guides and docs](https://hexdocs.pm/genetix).

<div align="center">
  <img width="400" height="250" src="guides/logo.png" onerror="this.onerror=null; this.src='assets/logo.png'">
</div>

**NOTE**: This framework is based on the `Genetic algorithms in Elixir: Solve Problems Using Evolution` The Pragmatic Programmers, by Sean Moriarity.

## Installation

Add `:genetix` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:genetix, "~> 0.1"}
  ]
end
```

## A quick example: Solving One-Max problem

The One-Max problem is a trivial problem: What is the maximum sum of a bitstring (a string consisting of only 1s and 0s) of length N.
You only need to define your `OneMax` problem and if you need it, define your own `hyperparameters` to customize its behavior (in that case, is not needed).

Remember, a basic genetic  problem consists of: `genotype/0`, `fitness_function/1`, and `terminate?/1`.  
  
  ```elixir
  defmodule OneMax do
    @behaviour Genetix.Problem
    alias Genetix.Types.Chromosome

    @impl true
    def genotype(opts \\ []) do
      # Notice that in this case, we use `size` as a hyperparameter to define the gene size.
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

You can run `Genetix.run(Genetix.Problems.OneMax, size: 100)` to solve the problem.

If you want, you can take a look to `genetix/problems` for other problems implemented as example.

## Tracking Genetic Algorithms

The goal of all the problems you are going to solve are related with optimize and objetive. In all the algorithms, you must to define the problem, configure the algorithm and run it until you obtain a solution. Sometimes you need a way to track the progress of an evolution over the time:

- Analyze how your population's fitness grew over time
- How the distribution of fitness changed between generations
- ...

Those insight can help you make decisions about how to reconfigure or adjust your algorithms.

For this purpose, `Genetix` provides `Statistics` that uses ETS to store the evolution of the population over time. You can override the default statistics with the `statistics` hyperparameter.

Once the algorithm ends you can access your statistics running `Utilities.Statistics.lookup/1` function.
An example of use:

```elixir
  iex> Genetix.run(Genetix.Problems.OneMax, size: 100)

  # once the algorithm ends
  iex>  {_, zero_gen_stats} = Utilities.Statistics.lookup(0)
  iex>  {_, fivethousand_gen_stats} = Utilities.Statistics.lookup(5000)
```

An example defining custom statistics:

```elixir
  
  def get_percentile_90(population) do
    sorted_population = Enum.map(population, fn c -> c.fitness end) |> Enum.sort()
    n = length(sorted_population)
    k = round(0.9 * n)
    
    if k == 0 do
      Enum.at(sorted_population, 0)
    else
      Enum.at(sorted_population, k - 1)
    end
  end 

  Genetix.run(Genetix.Problems.OneMax, size: 10, statistics: %{percentile_90: &get_percentile_90/1})

```

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

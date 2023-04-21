defmodule Utilities.Profiler do
  @moduledoc """
  Profile the performance of your genetic algorithm
  """
  import ExProf.Macro

  @dialyzer {:nowarn_function, run: 1}
  @dialyzer {:nowarn_function, run: 2}
  @spec run(Genetix.Problem, keyword()) :: :ok
  @doc "get analysis records and sum them up"
  def run(problem, opts \\ []) do
    {records, _block_result} = do_analyze(problem, opts)
    total_percent = Enum.reduce(records, 0.0, &(&1.percent + &2))
    IO.puts("Total percent = #{total_percent}")
  end

  @dialyzer {:nowarn_function, do_analyze: 2}
  defp do_analyze(problem, opts) do
    profile do
      Genetix.run(problem, opts)
    end
  end
end

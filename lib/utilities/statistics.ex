defmodule Utilities.Statistics do
  @moduledoc """
  Statistics server implementation
  """
  use GenServer

  def init(opts) do
    :ets.new(:statistics, [:set, :public, :named_table])
    {:ok, opts}
  end

  def start_link(opts) do
    GenServer.start(__MODULE__, opts, name: __MODULE__)
  end

  def insert(generation, statistics) do
    :ets.insert(:statistics, {generation, statistics})
  end

  def lookup(generation) do
    hd(:ets.lookup(:statistics, generation))
  end

  def clean() do
    :ets.delete_all_objects(:statistics)
  end
end

defmodule Genetix.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [{Utilities.Statistics, []}, {Utilities.Genealogy, []}]
    opts = [strategy: :one_for_one, name: Genetix.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

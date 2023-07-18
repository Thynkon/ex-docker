defmodule Docker do
  @doc """
  Given the name of a container, returns any matching IDs.
  """
  def find_ids(name, :partial) do
    name = name |> ExDocker.Names.container_safe() |> ExDocker.Names.api()

    ExDocker.Containers.list()
    |> Enum.filter(&match_partial_name(&1, name))
    |> Enum.map(& &1["Id"])
  end

  def find_ids(name) do
    name = name |> ExDocker.Names.container_safe() |> ExDocker.Names.api()

    ExDocker.Containers.list()
    |> Enum.filter(&(name in &1["Names"]))
    |> Enum.map(& &1["Id"])
  end

  defp match_partial_name(container, name) do
    container["Names"]
    |> Enum.any?(&(&1 == name || String.starts_with?(&1, "#{name}_")))
  end
end

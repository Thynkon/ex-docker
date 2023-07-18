defmodule ExDocker.Misc do
  @doc """
  Display system-wide information.
  """
  def info, do: ExDocker.Client.get("/info")

  @doc """
  Show the docker version information.
  """
  def version, do: ExDocker.Client.get("/version")

  @doc """
  Ping the docker server.
  """
  def ping, do: ExDocker.Client.get("/_ping")

  @doc """
  Monitor Docker's events.
  """
  def events(since), do: ExDocker.Client.get("/events?since=#{since}")
end

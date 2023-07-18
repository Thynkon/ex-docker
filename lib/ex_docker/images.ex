defmodule ExDocker.Images do
  @base_uri "/images"

  @doc """
  List all Docker images.
  """
  def list do
    ExDocker.Client.get("#{@base_uri}/json", query: %{all: "true"})
  end

  @doc """
  Return a filtered list of Docker images.
  """
  def list(filter) do
    ExDocker.Client.get("#{@base_uri}/json", query: %{filter: filter})
  end

  @doc """
  Inspect a Docker image by name or id.
  """
  def inspect(name) do
    "#{@base_uri}/#{name}/json?all=true" |> ExDocker.Client.get()
  end

  @doc """
  Pull a Docker image from the repo.
  """
  def pull(image), do: pull(image, "latest")

  def pull(image, tag) do
    "#{@base_uri}/create"
    |> ExDocker.Client.post("", query: %{fromImage: image, tag: tag})
  end

  @doc """
  Pull a Docker image from the repo after authenticating.
  """
  def pull(image, tag, auth) do
    auth_header = auth |> Jason.encode!() |> Base.encode64()
    headers = [{"x-registry-auth", auth_header}]

    "#{@base_uri}/create"
    |> ExDocker.Client.post("", headers: headers, query: %{fromImage: image, tag: tag})
  end

  @doc """
  Deletes a local image.
  """
  def delete(image) do
    (@base_uri <> "/" <> image) |> ExDocker.Client.delete()
  end
end

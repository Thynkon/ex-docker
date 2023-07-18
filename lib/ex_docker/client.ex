defmodule ExDocker.Client do
  @socket_path "unix:///var/run/docker.sock"
  @default_version "v1.36"

  defp base_url() do
    host = Application.get_env(:ex_docker, :host) || System.get_env("DOCKER_HOST", @socket_path)

    version =
      case Application.get_env(:ex_docker, :version) do
        nil -> @default_version
        version -> version
      end

    "#{normalize_host(host)}/#{version}"
    |> String.trim_trailing("/")
  end

  defp normalize_host("tcp://" <> host), do: "http://" <> host
  defp normalize_host("unix://" <> host), do: "http+unix://" <> URI.encode_www_form(host)

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url()},
      ExDocker.Middlewares.Response,
      ExDocker.Middlewares.ChunkedJson
    ]

    Tesla.client(middleware, Tesla.Adapter.Hackney)
  end

  @doc """
  Send a GET request to the Docker API at the speicifed resource.
  """
  def get(path, opts \\ []) do
    with {:ok, response} <- Tesla.get(client(), path, opts) do
      response |> Map.get(:body)
    end
  end

  @doc """
  Send a POST request to the Docker API, JSONifying the passed in data.
  """
  def post(path, data \\ %{}, opts \\ []) do
    with {:ok, response} <- Tesla.post(client(), path, data, opts) do
      response |> Map.get(:body)
    end
  end

  @doc """
  Send a DELETE request to the Docker API.
  """
  def delete(path, opts \\ []) do
    Tesla.delete(client(), path, opts)
  end
end

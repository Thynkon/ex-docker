defmodule Docker.Client do
  require Logger

  @socket_path "http+unix://" <> URI.encode_www_form("/var/run/docker.sock")

  defp base_url() do
    host = Application.get_env(:docker, :host) || System.get_env("DOCKER_HOST", @socket_path)
    endpoint =
      case Application.get_env(:docker, :version) do
        nil -> host
        version -> "#{host}/#{version}"
      end

    endpoint
    |> String.replace("tcp://", "http://")
    |> String.trim_trailing("/")
  end

  @default_headers %{"Content-Type" => "application/json"}

  @doc """
  Send a GET request to the Docker API at the speicifed resource.
  """
  def get(resource, headers \\ @default_headers) do
    Logger.debug "Sending GET request to the Docker HTTP API: #{resource}"
    base_url() <> resource
    |> HTTPoison.get!(headers)
    |> decode_body
  end

  @doc """
  Send a POST request to the Docker API, JSONifying the passed in data.
  """
  def post(resource, data \\ "", headers \\ @default_headers) do
    Logger.debug "Sending POST request to the Docker HTTP API: #{resource}, #{inspect data}"
    data = Poison.encode! data
    base_url() <> resource
    |> HTTPoison.post!(data, headers)
    |> decode_body
  end

  @doc """
  Send a DELETE request to the Docker API.
  """
  def delete(resource, headers \\ @default_headers) do
    Logger.debug "Sending DELETE request to the Docker HTTP API: #{resource}"
    base_url() <> resource
    |> HTTPoison.delete!(headers)
  end

  defp decode_body(%HTTPoison.Response{body: ""}) do
    Logger.debug "Empty response"
    :nil
  end
  defp decode_body(%HTTPoison.Response{body: body}) do
    Logger.debug "Decoding Docker API response: #{inspect body}"
    case Poison.decode(body) do
      {:ok, dict} -> dict
      {:error, _} -> body
    end
  end
end

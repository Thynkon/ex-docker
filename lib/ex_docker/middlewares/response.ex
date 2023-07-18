defmodule ExDocker.Middlewares.Response do
  @behaviour Tesla.Middleware

  alias ExDocker.Status

  def call(env, next, _) do
    with {:ok, result} <-
           env
           |> Tesla.run(next) do
      case result.status do
        code when code in [100, 200, 300] -> result.body
        code -> {:error, Status.reason_atom(code)}
      end
    end
  end
end

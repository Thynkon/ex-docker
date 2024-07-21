defmodule ExDocker.Middlewares.Response do
  @behaviour Tesla.Middleware

  alias ExDocker.Status

  def call(env, next, _) do
    with {:ok, result} <-
           env
           |> Tesla.run(next) do
      case result.status do
        code when code in [100, 200, 300] ->
          result.body

        code ->
          code_msg = Status.reason_atom(code)

          if Map.has_key?(result.body, "message") do
            {:error, code_msg, result.body["message"]}
          else
            {:error, code_msg}
          end
      end
    end
  end
end

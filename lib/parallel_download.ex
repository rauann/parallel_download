defmodule ParallelDownload do
  @moduledoc false
  use Tesla, only: [:get], docs: false

  @doc """
  Performs parallel GET requests on each given url.

  It uses the Elixir Task module to spawn one task (process) for each url and
  waits for their replies. The tasks run concurrently/parallel performing the GET
  requests with a timeout of 3s.

  When a url is not valid, the GET request is not ignored.
  """
  def run(urls \\ System.argv()) do
    tasks = for url <- urls, do: Task.async(fn -> do_run(url) end)

    tasks
    |> Task.yield_many(2000)
    |> Enum.each(&process_result/1)
  end

  defp process_result({_task, {:ok, {url, time, msg}}}) do
    IO.puts("GET #{url} -> #{time}ms #{msg}")
  end

  defp process_result({_task, {:ok, {:invalid_url, url}}}) do
    IO.puts("IGNORED #{url}")
  end

  defp process_result({_task, nil}) do
    IO.puts("TIMEOUT")
  end

  defp process_result({:exit, reason}) do
    IO.puts("ERROR #{inspect(reason)}")
  end

  defp do_run(url) do
    with true <- valid_url?(url),
         {time, {:ok, %{status: status}}} <- run_request(url) do
      {url, time, status}
    else
      {time, {:error, error}} ->
        {url, time, error}

      false ->
        {:invalid_url, url}
    end
  end

  defp valid_url?(url) do
    ValidUrl.validate(url)
  end

  defp run_request(url) do
    {microseconds, result} = :timer.tc(fn -> get(url) end)
    {to_milliseconds(microseconds), result}
  end

  defp to_milliseconds(microseconds) do
    System.convert_time_unit(microseconds, :microsecond, :millisecond)
  end
end

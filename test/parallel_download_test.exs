defmodule ParallelDownloadTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import Tesla.Mock

  setup %{result: result} do
    mock_global(fn %{method: :get} -> result.() end)

    :ok
  end

  def success_response, do: %Tesla.Env{status: 200}
  def failed_response, do: {:error, "some error"}
  def timeout_response, do: :timer.sleep(3000)

  @moduletag result: &__MODULE__.success_response/0

  test "performs parallel GET requests on each given url" do
    result =
      capture_io(fn ->
        ParallelDownload.run(~w(http://google.com http://www.bing.com))
      end)

    assert result =~ "GET http://google.com ->"
    assert result =~ "GET http://www.bing.com ->"
    assert result =~ "200"
  end

  test "ignores invalid urls" do
    result = capture_io(fn -> ParallelDownload.run(~w(htpp://not-a-web-url)) end)
    assert result =~ "IGNORED htpp://not-a-web-url"
  end

  @tag result: &__MODULE__.failed_response/0
  test "prints request error reason" do
    result = capture_io(fn -> ParallelDownload.run(~w(http://inactive-domain.blah)) end)
    assert result =~ "GET http://inactive-domain.blah ->"
    assert result =~ "some error"
  end

  @tag result: &__MODULE__.timeout_response/0
  test "prints timeout when request takes more than 2s" do
    result = capture_io(fn -> ParallelDownload.run(~w(http://not-responding.com)) end)
    assert result =~ "TIMEOUT"
  end
end

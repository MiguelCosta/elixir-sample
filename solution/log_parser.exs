defmodule LogParser do
  @verb_and_path ~r/Started (\w+) ("\S+")/
  @status_and_stats ~r/Completed (\d{3}) .* (in .+)$/

  def parse(logfile) do
    case File.read(logfile) do
      {:ok, file} ->
        String.split(file, "\n\n\n")
        |> Enum.map(&process_request/1)
        |> print_requests()

      {:error, error} ->
        IO.puts(error)
    end
  end

  defp process_request(parsed_request) do
    parsed_request
    |> String.split("\n")
    |> Enum.reduce(default_request(), &parse/2)
  end

  defp parse("Started" <> _rest = line, acc) do
    [verb, path] = Regex.run(@verb_and_path, line, capture: :all_but_first)
    %{acc | verb: verb, path: path}
  end

  defp parse("Completed" <> _rest = line, acc) do
    [status_code, stats] = Regex.run(@status_and_stats, line, capture: :all_but_first)
    %{acc | status_code: status_code, stats: stats}
  end

  defp parse(_, acc), do: acc

  defp default_request do
    %{
      verb: nil,
      path: nil,
      status_code: nil,
      stats: nil
    }
  end

  defp print_requests(parsed_requests) do
    Enum.each(parsed_requests, fn parsed_request ->
      IO.puts(
        "#{parsed_request.verb} #{parsed_request.path} => #{parsed_request.status_code} #{
          parsed_request.stats
        }"
      )
    end)
  end
end

# LogParser.parse("dev.log")

# Output

# POST "/admin/hard_drives" => 302 in 34ms (ActiveRecord: 26.6ms | Allocations: 2202)
# GET "/admin/hard_drives" => 200 in 27ms (Views: 23.7ms | ActiveRecord: 2.9ms | Allocations: 8874)
# GET "/admin/hard_drives/1/edit" => 200 in 19ms (Views: 13.0ms | ActiveRecord: 1.3ms | Allocations: 6705)

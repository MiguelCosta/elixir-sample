defmodule LogParser do
  def parser(logfile) do
    file = File.read!(logfile)
    requests = String.split(file, "\r\n\r\n\r\n")

    result =
      Enum.map(requests, fn request ->
        process_request(request)
      end)

    print_requests(result)
  end

  defp process_request(request) do
    lines = String.split(request, "\r\n")
    # first_line = List.first(lines)
    # last_line = List.last(lines)
    # last_line = lines |> Enum.reverse |> List.first

    default_request = %{
      verb: nil,
      path: nil,
      status_code: nil,
      stats: nil
    }

    Enum.reduce(lines, default_request, fn line, acc ->
      if matches = Regex.run(~r/Started (\w+) ("\S+")/, line, capture: :all_but_first) do
        %{acc | verb: Enum.at(matches, 0), path: Enum.at(matches, 1)}
      else
        if matches = Regex.run(~r/Completed (\d{3}) .* (in .+)$/, line, capture: :all_but_first) do
          %{acc | status_code: Enum.at(matches, 0), stats: Enum.at(matches, 1)}
        else
          acc
        end
      end
    end)
  end

  defp print_requests(parsed_requests) do
    Enum.each(parsed_requests, fn parsed_request ->
      IO.puts(
        "#{parsed_request[:verb]} #{parsed_request[:path]} => #{parsed_request[:status_code]} #{
          parsed_request[:stats]
        }"
      )
    end)
  end
end

LogParser.parser("log_parser_input.txt")

# OUTPUT
# POST "/admin/users" => 302 in 12ms
# GET "/admin/users/1" => 200 in 12ms
# GET "/admin/users/1/edit" => 200 in 12ms

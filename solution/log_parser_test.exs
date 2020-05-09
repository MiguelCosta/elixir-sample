Code.load_file("log_parser.exs", __DIR__)
ExUnit.start()

defmodule LogParserTest do
  use ExUnit.Case
  alias ExUnit.CaptureIO, as: CIO

  test "outputs an abbreviated version of the log" do
    assert CIO.capture_io(fn -> LogParser.parse("dev.log") end) == """
           POST "/admin/hard_drives" => 302 in 34ms (ActiveRecord: 26.6ms | Allocations: 2202)
           GET "/admin/hard_drives" => 200 in 27ms (Views: 23.7ms | ActiveRecord: 2.9ms | Allocations: 8874)
           GET "/admin/hard_drives/1/edit" => 200 in 19ms (Views: 13.0ms | ActiveRecord: 1.3ms | Allocations: 6705)
           """
  end
end

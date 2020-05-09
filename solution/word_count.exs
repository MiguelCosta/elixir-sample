defmodule WordCount do
  def count(line) do
    line
    |> String.downcase()
    |> String.replace(~r/[^\w\s-']/u, "")
    |> String.split(~r/[\s_]+/)
    |> Enum.reduce(%{}, &count_occurences/2)
  end

  defp count_occurences(word, acc) do
    Map.update(acc, word, 1, &(&1 + 1))
  end
end

# elixir-sample

## Install on windows

Install with chocolatey

```bash
cinst elixir
```

## Days

### Day 1

Live sesstion: https://drive.google.com/open?id=1qq5YepoEwbTiM6_h1LskSf2Arg-jKGer&authuser=0

LogParser

```
elixir log_parser.exs
```

*Challenge:*

Create an .exs file that you can run with the elixir command. Once that is set up, create a module that given a phrase, counts the occurrences of each word in that phrase.

For example for the input "this is great, isn't this?"

We should get the following output

```
{ "this" => 2, "is" => 1, "great" => 1, "isn't" => 1}
```

Notes:
"isn't" is actually the abbreviation of two works, let's ignore that.
the question mark should be ignored

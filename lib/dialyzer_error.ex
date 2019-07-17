defmodule DialyzerError do

  @doc """
  Invalid contract as count can be `non_neg_integer` or `nil` in
  the default case.

  Dialyzer should produce a warning based on the fact count may be `nil`.

  Instead against Erlang 22 and Elixir 1.9 the following crash occurs:
  ```
  ** (MatchError) no match of right hand side value: {:error, {1, :erl_parse, ['syntax error before: ', '\'::\'']}}
    (dialyzer) dialyzer.erl:626: anonymous fn/1 in :dialyzer.sig/2
    (dialyzer) dialyzer.erl:541: :dialyzer.call_or_apply_to_string/6
    (dialyzer) dialyzer.erl:322: :dialyzer.message_to_string/2
    (dialyzer) dialyzer.erl:297: :dialyzer.format_warning/2
    (dialyxir) lib/dialyxir/formatter.ex:106: Dialyxir.Formatter.format_warning/2
    (dialyxir) lib/dialyxir/formatter.ex:275: anonymous fn/2 in Dialyxir.Formatter.filter_legacy_warnings/2
    (elixir) lib/enum.ex:3029: Enum.reject_list/2
    (elixir) lib/enum.ex:3032: Enum.reject_list/2
  ```

  Should show the following dialyzer warning:
  ```
  lib/dialyzer_error.ex:30:call
  The function call will not succeed.

  DialyzerError.crashes(nil)

  breaks the contract
    (count :: non_neg_integer()) :: :ok
  ```
  """
  @spec crashes(count :: non_neg_integer()) :: :ok
  def crashes(count \\ nil) do
    count = count || 0
    IO.puts("count: #{count}")
    :ok
  end


  @doc """
  This function has the same contract error but with the naming of the type
  `count :: ` removed from the `@spec`.

  Dialyzer produces to the correct result:
  ```
  lib/dialyzer_error.ex:56:call
  The function call will not succeed.

  DialyzerError.produces_proper_type_error(nil)

  breaks the contract
    (non_neg_integer()) :: :ok
  ```
  """
  @spec produces_proper_type_error(non_neg_integer()) :: :ok
  def produces_proper_type_error(count \\ nil) do
    count = count || 0
    IO.puts("count: #{count}")
    :ok
  end

  @doc """
  If the `@spec` is correct the presence of the name `count ::` does not
  result in a crash, as it looks like dialyxir only has error when parsing/
  matching on the return dialyzer error.  The format of which must have changed
  in Erlang 22.
  """
  @spec passes(count :: non_neg_integer() | nil) :: :ok
  def passes(count \\ nil) do
    count = count || 0
    IO.puts("count: #{count}")
    :ok
  end
end

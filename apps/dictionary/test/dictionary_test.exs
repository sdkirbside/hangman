defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "returns a word" do
    assert String.length(Dictionary.random_word) > 0
  end
end

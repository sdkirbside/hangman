defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList
  use Agent

  @type t :: pid()

  def random_word do
    Agent.get(__MODULE__, &WordList.random_word/1)
  end

  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: __MODULE__)
  end
end

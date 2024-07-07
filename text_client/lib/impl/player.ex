defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start :: :ok
  def start do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({ game, tally })
  end

  @spec interact(state) :: :ok
  def interact({ _game, tally = %{ game_state: :won }}) do
    IO.puts IO.ANSI.format([:green, "Winner winner chicken dinner! The word was #{Enum.join(tally.letters)}."])
  end

  def interact({ _game, tally = %{ game_state: :lost }}) do
    IO.puts IO.ANSI.format([:red, "Loser loser soup for supper! The word was #{Enum.join(tally.letters)}."])
  end

  def interact({ game, tally }) do
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)
    IO.puts ""
    Hangman.make_move(game, get_guess())
    |> interact()
  end

  ############################################################

  defp current_word(tally) do
    [
      "Word so far: ", Enum.join(tally.letters, " "),
      " | Guesses left: ", Integer.to_string(tally.turns_left),
      " | Guessed so far: ", Enum.join(tally.used, ", ")
    ]
  end

  defp feedback_for(_tally = %{ game_state: :already_used }) do
    IO.ANSI.format([:yellow, "Oops, you already guessed that."])
  end

  defp feedback_for(_tally = %{ game_state: :bad_guess }) do
    IO.ANSI.format([:red, "Sorry, that's not in this word."])
  end

  defp feedback_for(_tally = %{ game_state: :good_guess }) do
    IO.ANSI.format([:green, "Nice, that was a superb choice."])
  end

  defp feedback_for(tally = %{ game_state: :initializing }) do
    IO.ANSI.format([:white, "Hiya! I'm thinking of a #{length(tally.letters)} letter word..."])
  end

  defp get_guess do
    IO.gets("Guess? ")
    |> String.trim()
    |> String.downcase()
  end
end

defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new game returns structure" do
    game =  Game.new_game
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game =  Game.new_game("wombat")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    { game, _tally } = Game.make_move(game, "y")
    { game, _tally } = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    { game, _tally } = Game.make_move(game, "m")
    assert game.game_state == :good_guess
    { game, _tally } = Game.make_move(game, "t")
    assert game.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new_game("wombat")
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    { game, _tally } = Game.make_move(game, "m")
    assert game.game_state == :good_guess
    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state == :bad_guess
  end

  test "can handle a sequence of moves" do
    [
      [ "a",  :bad_guess,     6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "a",  :already_used,  6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "e",  :good_guess,    6,  [ "_", "e", "_", "_", "_" ],  [ "a", "e" ] ],
      [ "x",  :bad_guess,     5,  [ "_", "e", "_", "_", "_" ],  [ "a", "e", "x" ] ],
    ]
    |> test_sequence_of_moves("hello")
  end

  test "can handle a winning game" do
    [
      [ "w",  :good_guess,  7,  [ "w", "_", "_" ],  [ "w" ] ],
      [ "i",  :good_guess,  7,  [ "w", "i", "_" ],  [ "i", "w" ] ],
      [ "n",  :won,         7,  [ "w", "i", "n" ],  [ "i", "n", "w" ] ],
    ]
    |> test_sequence_of_moves("win")
  end

  test "can handle a losing game" do
    [
      [ "f",  :bad_guess, 6,  [ "_", "_", "_" ],  [ "f" ] ],
      [ "a",  :bad_guess, 5,  [ "_", "_", "_" ],  [ "a", "f" ] ],
      [ "i",  :bad_guess, 4,  [ "_", "_", "_" ],  [ "a", "f", "i" ] ],
      [ "l",  :bad_guess, 3,  [ "_", "_", "_" ],  [ "a", "f", "i", "l" ] ],
      [ "u",  :bad_guess, 2,  [ "_", "_", "_" ],  [ "a", "f", "i", "l", "u" ] ],
      [ "r",  :bad_guess, 1,  [ "_", "_", "_" ],  [ "a", "f", "i", "l", "r", "u" ] ],
      [ "e",  :lost,      0,  [ "_", "_", "_" ],  [ "a", "e", "f", "i", "l", "r", "u" ] ],
    ]
    |> test_sequence_of_moves("not")
  end

  ############################################################

  defp check_one_move([ guess, state, turns, letters, used ], game) do
    { game, tally } = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used
    game
  end

  defp test_sequence_of_moves(script, word) do
    game = Game.new_game(word)
    Enum.reduce(script, game, &check_one_move/2)
  end
end

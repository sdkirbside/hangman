defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game
  use GenServer

  @type t :: pid()

  def handle_call({ :make_move, guess }, _from, game) do
    { updated_game, tally } = Game.make_move(game, guess)
    { :reply, tally, updated_game }
  end

  def handle_call({ :tally }, _from, game) do
    { :reply, Game.tally(game), game }
  end

  def init(_) do
    { :ok, Game.new_game }
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end
end

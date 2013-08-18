require_relative 'player'
require_relative 'board'
require_relative 'piece'

class Checkers
  attr_accessor :board

  def initialize
    @board = Board.new

    @players = {
      :black => HumanPlayer.new('black'),
      :white => HumanPlayer.new('white')
    }

    puts "Player 1 is red"
    puts "Player 2 is white"

    @current_player = :black

    play_game
  end

  def play_game
    until board.game_over?
      puts board
      if @players[@current_player].color == 'black'
        puts "red player's turn"
      else
        puts "#{@players[@current_player].color} player's turn"
      end
      @players[@current_player].make_move(@board)
      @current_player = @current_player == :black ? :white : :black
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Checkers.new
end
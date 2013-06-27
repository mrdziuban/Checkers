require_relative 'player'
require_relative 'board'
require_relative 'piece'

# REV: general note - you don't need to use '@' before instance variables
#      that you've declared using attr_accessor. You can just use the name
#      of the variable. It's better to leave the '@' out because it'll just 
#      create a variable out of thin air if you typo the variable name or
#      introduce some other similar bug
class Checkers
  attr_accessor :board

  def initialize
    @board = Board.new

    @players = {
      :black => HumanPlayer.new('black'),
      :white => HumanPlayer.new('white')
    }

    # REV: mixing up red and black is a little confusing for the non-white
    #      player is a little confusing
    puts "Player 1 is red"
    puts "Player 2 is white"

    @current_player = :black

    play_game
  end

  def play_game
    # REV: it might be better to call this game_over?, since it might
    #      be interpreted as meaning that only when _NO_ pieces are
    #      left (rather than none of 1 player's pieces left) will the
    #      game end
    while @board.pieces_left?
      @board.render
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

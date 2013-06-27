require_relative 'board'
require_relative 'piece'
require_relative 'checkers'

class HumanPlayer
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def make_move(board) # board is Board object
    begin
      move_sequence = get_move_sequence
      piece = board.board[move_sequence[0][0]][move_sequence[0][1]]
      if piece == "_"
        raise InvalidMoveError.new "That's not a piece."
      elsif piece.color != self.color
        raise InvalidMoveError.new "You can't move the other player's piece."
      end
      piece.perform_moves(move_sequence, board) # board is Board object
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end

  def get_move_sequence
    print "Enter your move sequence: "
    str = gets.chomp.split.map {|i| [i]}
    sequence = []

    str.each do |x|
      x.each do |y|
        temp = y.split(",")
        temp.map! {|z| z.to_i}
        sequence << temp
      end
    end
    sequence
  end
end




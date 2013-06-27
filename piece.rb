# encoding: UTF-8
require 'debugger'

class Piece
  attr_accessor :color, :location, :representation

  def initialize(color, location)
    @color = color
    @location = location

    @representation = @color == 'black' ? "⛂" : "⛀"
  end

  def valid_move?(start_point, end_point, board)
    start = board[start_point[0]][start_point[1]]
    final = board[end_point[0]][end_point[1]]
    delta_y = end_point[0] - start_point[0]
    delta_x = end_point[1] - start_point[1]
    p delta_y
    p delta_x

    y_direction = start.color == 'black' ? 1 : -1

    # Moves must be diagonal, one or two spaces
    if delta_y.abs != delta_x.abs || delta_y.abs > 2 || delta_x.abs > 2
      return [false, 'Move must be diagonal']
    end

    # If moving one space, start point must be a piece and end must not be
    if delta_y.abs == 1
      # Must jump a piece if there's one to jump
      if piece_to_jump?(start_point, y_direction, board)
        return [false, 'Must jump piece if available']
      elsif start.is_a?(Piece) && !final.is_a?(Piece)
        return [true, 'slide']
      end
    end

    # If moving more than one space, space in between has to be a piece
    if delta_y.abs > 1
      if delta_x == 2
        diagonal_one = board[start_point[0] + y_direction][start_point[1] + 1]
      elsif x == -2
        diagonal_one = board[start_point[0] + y_direction][start_point[1] - 1]
      end

      if start.is_a?(Piece) && diagonal_one.is_a?(Piece)
        return [true, 'jump']
      end
    end
    [false]
  end

  def piece_to_jump?(start_loc, y_direction, board)
    if board[start_loc[0] + y_direction][start_loc[1] + 1].is_a?(Piece) && board[start_loc[0] + y_direction][start_loc[1] + 1] != self.color
      return [true, board[start_loc[0] + y_direction][start_loc[1] + 1]]
    elsif board[start_loc[0] + y_direction][start_loc[1] - 1].is_a?(Piece) && board[start_loc[0] + y_direction][start_loc[1] - 1] != self.color
      return [true, board[start_loc[0] + y_direction][start_loc[1] - 1]]
    end
    false
  end
end
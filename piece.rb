# encoding: UTF-8
require 'debugger'

class InvalidMoveError < StandardError
end

class Piece
  attr_accessor :color, :location, :representation

  def initialize(color, location)
    @color = color
    @location = location

    @representation = @color == 'black' ? "⛂" : "⛀"
  end

  def perform_moves!(move_sequence, board)
    move_sequence.each_with_index do |move, index|
      next if index + 1 == move_sequence.length

      point1 = move_sequence[index]
      point2 = move_sequence[index + 1]

      delta_y = point2[0] - point1[0]

      if delta_y.abs == 1
        slide_moves(point1, point2, board)
      else
        jump_moves(point1, point2, board)
      end
    end
  end

  def perform_moves(move_sequence, board)
    if valid_move_seq?(move_sequence, board)
      perform_moves!(move_sequence, board)
    else
      raise InvalidMoveError.new
    end
  end

  def valid_move_seq?(move_sequence, board)
    begin
      perform_moves!(move_sequence, board.dup)
    rescue InvalidMoveError
      return false
    end
    true
  end

  def slide_moves(start_point, end_point, board)
    # debugger
    delta_y = end_point[0] - start_point[0]
    delta_x = end_point[1] - start_point[1]

    start = board[start_point[0]][start_point[1]]
    final = board[end_point[0]][end_point[1]]

    y_direction = start.color == 'black' ? 1 : -1

    if delta_y.abs != delta_x.abs || delta_y.abs > 2 || delta_x.abs > 2
      raise InvalidMoveError.new
    end

    # Must jump a piece if there's one to jump
    if piece_to_jump?(start_point, y_direction, board)
      raise InvalidMoveError.new
    elsif start.is_a?(Piece) && !final.is_a?(Piece)
      board[start_point[0]][start_point[1]], board[end_point[0]][end_point[1]] = board[end_point[0]][end_point[1]], board[start_point[0]][start_point[1]]
    end
  end

  def jump_moves(start_point, end_point, board)
    delta_y = end_point[0] - start_point[0]
    delta_x = end_point[1] - start_point[1]

    start = board[start_point[0]][start_point[1]]
    final = board[end_point[0]][end_point[1]]

    y_direction = start.color == 'black' ? 1 : -1

    if delta_y.abs != delta_x.abs || delta_y.abs > 2 || delta_x.abs > 2
      raise InvalidMoveError.new
    end

    if delta_x == 2
      diagonal_one = board[start_point[0] + y_direction][start_point[1] + 1]
    elsif delta_x == -2
      diagonal_one = board[start_point[0] + y_direction][start_point[1] - 1]
    end

    if start.is_a?(Piece) && diagonal_one.is_a?(Piece)
      board[start_point[0]][start_point[1]], board[end_point[0]][end_point[1]] = board[end_point[0]][end_point[1]], board[start_point[0]][start_point[1]]
      diagonal_one = "_"
    else
      raise InvalidMoveError.new
    end
  end

  def piece_to_jump?(start_loc, y_direction, board)
    if start_loc[0] == 0 || start_loc[0] == 7
      y_direction = 0
    elsif start_loc[1] == 0 || start_loc[0] == 7
      increments = [0]
    else
      increments = [1,-1]
    end

    increments.each do |inc|
      if board[start_loc[0] + y_direction][start_loc[1] + inc].is_a?(Piece) && board[start_loc[0] + y_direction][start_loc[1] + 1] != self.color
        return true
      elsif board[start_loc[0] + y_direction][start_loc[1] - inc].is_a?(Piece) && board[start_loc[0] + y_direction][start_loc[1] - 1] != self.color
        return true
      end
    end
    false
  end
end
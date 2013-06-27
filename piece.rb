# encoding: UTF-8
require 'debugger'

class InvalidMoveError < StandardError
end

class Piece
  # REV: instead of using ':representation' for the icon, you could
  #      override the to_s method instead
  attr_accessor :color, :location, :representation

  def initialize(color, location)
    @color = color
    @location = location

    @representation = @color == 'black' ? "⛂" : "⛀"
  end

  def perform_moves!(move_sequence, board) # board is array
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

    if self.color == 'black' && self.location[0] == 7
      promotion
    elsif self.color == 'white' && self.location[0] == 0
      promotion
    end
  end

  def perform_moves(move_sequence, board) # board is Board object
    if valid_move_seq?(move_sequence, board)
      perform_moves!(move_sequence, board.board)
    else
      # REV: you can leave out the ".new" here
      raise InvalidMoveError.new
    end
  end

  def valid_move_seq?(move_sequence, board) # board is Board object
    board_dup = board.duplicate_board
    begin
      perform_moves!(move_sequence, board_dup) # board_dup is array
    rescue InvalidMoveError => e
      puts e.message
      return false
    end
    true
  end

  # REV: slide_moves and jump_moves are really long - can they be broken
  #      up into submethods?
  def slide_moves(start_point, end_point, board) # board should be array
    delta_y = end_point[0] - start_point[0]
    delta_x = end_point[1] - start_point[1]

    start = board[start_point[0]][start_point[1]]
    final = board[end_point[0]][end_point[1]]

    raise InvalidMoveError.new "There's a piece in the way." if final.is_a?(Piece)

    y_direction = delta_y if is_king?
    y_direction = self.color == 'black' ? 1 : -1

    unless is_king?
      if delta_y > 0 && y_direction < 0
        raise InvalidMoveError.new "You can't move backwards."
      elsif delta_y < 0 && y_direction > 0
        raise InvalidMoveError.new "You can't move backwards."
      end
    end

    if delta_y.abs != delta_x.abs || delta_y.abs > 2 || delta_x.abs > 2
      raise InvalidMoveError.new "You must move diagonally."
    end

    # Must jump a piece if there's one to jump
    if piece_to_jump?(start_point, y_direction, board)
      raise InvalidMoveError.new "You must jump a piece if possible."
    end

    if start.is_a?(Piece)
      board[start_point[0]][start_point[1]], board[end_point[0]][end_point[1]] = board[end_point[0]][end_point[1]], board[start_point[0]][start_point[1]]
      self.location = end_point
    end
  end

  def jump_moves(start_point, end_point, board)
    delta_y = end_point[0] - start_point[0]
    delta_x = end_point[1] - start_point[1]

    start = board[start_point[0]][start_point[1]]
    final = board[end_point[0]][end_point[1]]

    raise InvalidMoveError.new "There's a piece in the way." if final.is_a?(Piece)

    y_direction = self.color == 'black' ? 1 : -1
    y_direction = delta_y / 2 if is_king?

    unless is_king?
      if delta_y > 0 && y_direction < 0
        raise InvalidMoveError.new "You can't move backwards."
      elsif delta_y < 0 && y_direction > 0
        raise InvalidMoveError.new "You can't move backwards."
      end
    end

    if delta_y.abs != delta_x.abs || delta_y.abs > 2 || delta_x.abs > 2
      raise InvalidMoveError.new "You must move diagonally."
    end

    if delta_x == 2
      diagonal_one = board[start_point[0] + y_direction][start_point[1] + 1]
    elsif delta_x == -2
      diagonal_one = board[start_point[0] + y_direction][start_point[1] - 1]
    end

    if start.is_a?(Piece) && diagonal_one.is_a?(Piece)
      board[start_point[0]][start_point[1]], board[end_point[0]][end_point[1]] = board[end_point[0]][end_point[1]], board[start_point[0]][start_point[1]]
      self.location = end_point
      board[diagonal_one.location[0]][diagonal_one.location[1]] = "_"
    else
      raise InvalidMoveError.new "You can only jump when there's a piece there."
    end
  end

  def piece_to_jump?(start_loc, y_direction, board)
    # if start_loc[0] == 0 || start_loc[0] == 7 && !is_king?
    #   y_direction = 0
    if start_loc[1] == 0
      increments = [1]
    elsif start_loc[1] == 7
      increments = [-1]
    else
      increments = [1,-1]
    end

    increments.each do |inc|
      if board[start_loc[0] + y_direction][start_loc[1] + inc].is_a?(Piece) && \
        board[start_loc[0] + y_direction][start_loc[1] + 1] != self.color && \
        !board[start_loc[0] + y_direction * 2][start_loc[1] + inc * 2].is_a?(Piece)
        if start_loc[1] + inc != 7 && start_loc[1] + inc != 0
          return true
        end
      end
    end
    false
  end

  def promotion
    if self.color == 'black'
      self.representation = "⛃"
    else
      self.representation = "⛁"
    end
  end

  def is_king?
    return true if self.representation == "⛃" || self.representation == "⛁"
    false
  end
end

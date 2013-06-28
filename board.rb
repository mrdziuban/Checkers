# encoding: UTF-8
require 'colorize'
require_relative 'piece'

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) {Array.new(8)}

    place_pieces
  end

  def place_pieces
    piece_rows = [(0..2), (5..7)]
    piece_rows.each do |range|
      range.each do |row|
        color = row < 3 ? 'black' : 'white'
        (0..7).each do |col|
          if (row + col).odd?
            @board[row][col] = Piece.new(color, [row,col])
          end
        end
      end
    end
  end

  def render
    to_s
  end

  def to_s
    board_string = "  "
    (0..7).each {|x| board_string += " #{x} "}
    board_string += "\n"
    @board.each_with_index do |row, i|
      board_string += "#{i} "
      row.each_with_index do |char, j|
        if (i + j).even?
            board_string += "   ".colorize(:background => :red)
        elsif (i + j).odd?
          if char.nil?
            board_string += "   ".colorize(:color => :white, :background => :black)
          elsif char.color == 'black'
            board_string += " #{char.representation} ".colorize(:color => :red, :background => :black)
          else
            board_string += " #{char.representation} ".colorize(:color => :white, :background => :black)
          end
        end
      end
      board_string += "\n"
    end
    board_string
  end

  def game_over?
    white_pieces = []
    black_pieces = []
    @board.flatten.each do |char|
      white_pieces << char if char.is_a?(Piece) && char.color == 'white'
      black_pieces << char if char.is_a?(Piece) && char.color == 'black'
    end
    return true if white_pieces.compact.empty? || black_pieces.compact.empty?
    false
  end

  def duplicate_board
    board_dup = []
    self.board.each do |row|
      board_dup << row.dup
    end
    board_dup
  end
end
# encoding: UTF-8
require 'colorize'
require_relative 'piece'

class Board
  attr_accessor :board

  def initialize
    @board = []
    8.times do
      @board << ["_"] * 8
    end

    place_pieces
  end

  def place_pieces
    (0..2).each do |row|
      (0..7).each do |col|
        if (row + col).odd?
          @board[row][col] = Piece.new('black', [row,col])
        end
      end
    end
    (5..7).each do |row|
      (0..7).each do |col|
        if (row + col).odd?
          @board[row][col] = Piece.new('white', [row,col])
        end
      end
    end
  end

  def render
    print "  "
    (0..7).each {|x| print " #{x} "}
    puts
    @board.each_with_index do |row, i|
      print "#{i} "
      row.each_with_index do |char, j|
        if (i + j).even?
            print "   ".colorize(:background => :red)
        elsif (i + j).odd?
          if char.is_a? String
            print "   ".colorize(:color => :white, :background => :black)
          elsif char.color == 'black'
            print " #{char.representation} ".colorize(:color => :red, :background => :black)
          else
            print " #{char.representation} ".colorize(:color => :white, :background => :black)
          end
        end
      end
      puts
    end
    nil
  end

  def pieces_left?
    white_pieces = []
    black_pieces = []
    @board.each do |row|
      row.each do |char|
        white_pieces << char if char.is_a?(Piece) && char.color == 'white'
        black_pieces << char if char.is_a?(Piece) && char.color == 'black'
      end
    end
    return false if white_pieces.empty? || black_pieces.empty?
    true
  end

  def duplicate_board
    board_dup = []
    self.board.each do |row|
      board_dup << row.dup
    end
    board_dup
  end
end
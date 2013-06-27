# encoding: UTF-8
require 'colorize'
require_relative 'piece'

class Board
  attr_accessor :board

  def initialize
    # REV: you can do the following 4 lines in 1 line by just running:
    # @board = Array.new(8) {Array.new(8)}
    @board = []
    8.times do
      @board << [nil] * 8
    end

    place_pieces
  end

  def place_pieces
    # REV: the first and second halves of this method are repetitive.
    #      They be condensed into one block of code.
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

  # REV: it might be better to instead make this a to_s method that instead
  #      constructs a string for the whole board (using '\n' characters)
  #      and returns the whole string. That way, you can run 'p board'
  #      from the debugger and any point to easily get the board, and you
  #      can save the board string to view at a later point, if needed.
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
          if char.nil?
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
    @board.flatten.each do |char|
      white_pieces << char if char.is_a?(Piece) && char.color == 'white'
      black_pieces << char if char.is_a?(Piece) && char.color == 'black'
    end
    return false if white_pieces.compact.empty? || black_pieces.compact.empty?
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

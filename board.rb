# encoding: UTF-8
require 'colored'
require './piece.rb'

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
            print "   ".white_on_red
        elsif (i + j).odd?
          if char.is_a? String
            print "   ".white_on_black
          elsif char.color == 'black'
            print " #{char.representation} ".red_on_black
          else
            print " #{char.representation} ".white_on_black
          end
        end
      end
      puts
    end
  end
  nil
end
# frozen_string_literal: true

require_relative "ChessEngine/version"
require 'square'
require 'figure'
require 'chess_board'

module ChessEngine
  class Error < StandardError; end
  # Your code goes here...
  
  b = ChessBoard.new('test_reading.txt')
  s = Square.new(Colors::WHITE, Pawn.new(true), {y: 1, x: 1})
  b.print_board
  b.save_board('test.txt')
  ms = b.generate_diagonal(s, 4)
  puts ms.size
end

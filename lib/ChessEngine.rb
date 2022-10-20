# frozen_string_literal: true

require_relative "ChessEngine/version"
require 'square'
require 'figure'
require 'chess_board'

module ChessEngine
  class Error < StandardError; end
  # Your code goes here...
  
  b = ChessBoard.new(nil)
  s = Square.new(Colors::WHITE, Pawn.new("Pawn", 'W'), {y: 1, x: 1})
  b.print_board
  ms = b.generate_diagonal(s, 4)
  puts ms.size
end

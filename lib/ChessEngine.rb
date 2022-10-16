# frozen_string_literal: true

require_relative "ChessEngine/version"
require 'square'
require 'figure'
require 'chess_board'

module ChessEngine
  class Error < StandardError; end
  # Your code goes here...
  
  b = ChessBoard.new(nil)
  #b.print_board
  s = Square.new(Colors::WHITE, Figure.new("Pawn", 'W'), {y: 4, x: 4})
  ms = b.generate_diagonal(s, 4)
  puts ms.size
end

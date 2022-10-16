# frozen_string_literal: true

require_relative "ChessEngine/version"
require 'square'
require 'figure'
require 'chess_board'

module ChessEngine
  class Error < StandardError; end
  # Your code goes here...
  b = ChessBoard.new(nil)
  b.print_board
end

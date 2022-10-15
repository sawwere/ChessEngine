# frozen_string_literal: true

require_relative "ChessEngine/version"
require 'square'
require 'figure'

module ChessEngine
  class Error < StandardError; end
  # Your code goes here...

  s = Square.new(Colors::WHITE, Figure.new("pawn"), {a: 1})
  s.test(1);
end

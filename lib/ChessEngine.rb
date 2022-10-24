# frozen_string_literal: true

require_relative "ChessEngine/version"
require 'square'
require 'figure'
require 'chess_board'

module ChessEngine
  class Error < StandardError; end

  class  ChessMatch
    def initialize(filename)
      @filename = filename
      @board = ChessBoard.new(filename)
      @history = Array.new
      #TODO добавить необходимые флаги
      @checks = { white_turn: true, white_castling: true, black_castling: true }
      @whites = @board.get_figures(true )
      @blacks = @board.get_figures(false )
    end

    def start
      while true
        self.next(gets.chomp)
      end
    end

    def next(string)
      #TODO распарсить входную сроку с командой
      # проверка правильности строки
      # return true - false
    end

    private def execute_move(square_from, square_to)
      #TODO проверка типа фигуры и может ли она переместиться в указанную клетку
      # return true - false
      @history.append( {from: square_from, to: square_to})
    end

    private def execute_print_board
      @board.print_board
    end

    private def execute_print_history
      @board.print_board
    end

    private def execute_save(filename)
      @board.save_board(filename)
      #TODO сохранить историю ходов
    end


  end

  game = ChessMatch.new('test_reading.txt')
  game.start
  
  b = ChessBoard.new('test_reading.txt')
  s = Square.new(Pawn.new(true), {y: 1, x: 1})
  b.print_board
  b.save_board('test.txt')
  ms = b.generate_diagonal(s, 4)
  puts ms.size

end

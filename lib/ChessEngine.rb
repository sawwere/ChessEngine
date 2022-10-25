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
        self.next(0)
        break
      end

    end

    def next(string)
      #TODO распарсить входную сроку с командой
      # проверка правильности строки
      # return true - false
      puts execute_move(@board[6, 1], @board[6, 3])
      @checks[:white_turn] = !@checks[:white_turn]
      execute_print_board

      # puts execute_move(@board[4, 6], @board[4, 4])
      # @checks[:white_turn] = !@checks[:white_turn]
      # execute_print_board
      #
      # puts execute_move(@board[5, 1], @board[5, 2])
      # @checks[:white_turn] = !@checks[:white_turn]
      # execute_print_board
      #
      # puts @board[4,6].get_occupied_by.nil?
      #
      # puts execute_move(@board[3, 7], @board[4, 6])
      # @checks[:white_turn] = !@checks[:white_turn]
      # execute_print_board
    end

    def king_under_attack?
      king_square = @board.get_king(@checks[:white_turn])
      enemy_attack = @board.get_all_moves(!@checks[:white_turn], @checks)
      enemy_attack.include?(king_square)
    end

    private def execute_move(square_from, square_to)
      #TODO проверка типа фигуры и может ли она переместиться в указанную клетку
      # return true - false

      puts square_from.get_occupied_by
      puts square_from.get_coordinates
      possible_moves = square_from.get_occupied_by.generate_moves(square_from, @checks)

      puts possible_moves
      if possible_moves.include?(square_to)
        from_fig = square_from.get_occupied_by
        to_fig = square_from.get_occupied_by

        to = square_to.get_coordinates
        @board[to[:x], to[:y]].set_occupied_by(@board[to[:x], to[:y]].get_occupied_by)

        from = square_from.get_coordinates
        @board[from[:x], from[:y]].set_occupied_by(nil)

        if king_under_attack?
          square_to.set_occupied_by(to_fig)
          square_from.set_occupied_by(from_fig)
          puts "==============="
          return false
        end
        @history.append(square_from, square_to )
        return true

      end
      false
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
  
  # b = ChessBoard.new('test_reading.txt')
  # s = Square.new(Pawn.new(true, self), {y: 1, x: 1})
  # b.print_board
  # b.save_board('test.txt')
  # ms = b.generate_diagonal(s, 4)
  # puts ms.size

end

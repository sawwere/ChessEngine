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
      @checks = { white_turn: true, white_castling: true, black_castling: true, white_check: false , black_check: false }
      @whites = @board.get_figures(true )
      @blacks = @board.get_figures(false )
    end

    def start
      while true
        puts 'пожалуйста введите ход'
        input = gets.chomp
        if input == '/exit'
          break
        elsif input == '/print'
          execute_print_board
          else
        self.next(input)
        end

        break
      end
    end

    def next(string)
      horizontal = 'abcdefgh'
      #current_move = string.split('.').first
      move = string.split('.').last
      if  move == '0-0-0' or move == '0-0'
        #TODO Добавить рокировку
        p 'castling is done'
      elsif move.include? '-'
        is_quiet_move = true
        from_cell,to_cell = split_move(move,'-')
        if check_input(from_cell,to_cell,horizontal)
          p 'Неправильно введён ход, попробуйте ещё раз'
          return false
        end
        puts execute_move(@board[horizontal.index(from_cell[0]), 8-from_cell[1].to_i], @board[horizontal.index(to_cell[0]), 8-to_cell[1].to_i])
        p 'quiet_move is done'
      elsif move.include? 'x'
        is_quiet_move = false
        from_cell,to_cell = split_move(move,'x')
        if check_input(from_cell,to_cell,horizontal)
          p 'Неправильно введён ход, попробуйте ещё раз'
          return false
        end
        puts execute_move(@board[horizontal.index(from_cell[0]), 8-from_cell[1].to_i], @board[horizontal.index(to_cell[0]), 8-to_cell[1].to_i])
        p 'not quiet_move is done'
      else
        p 'Неправильно введён ход, попробуйте ещё раз'
        return false
      end
      #TODO НЕ УДАЛЯТЬ ПОКА НЕТ ТЕСТОВ
      #
      # puts execute_move(@board[4, 6], @board[4, 5])
      # @checks[:white_turn] = !@checks[:white_turn]
      # execute_print_board
      #
      # puts execute_move(@board[5, 1], @board[5, 3])
      # @checks[:white_turn] = !@checks[:white_turn]
      #
      # puts execute_move(@board[3, 7], @board[7, 3])
      # @checks[:white_turn] = !@checks[:white_turn]
      #
      # puts execute_move(@board[6, 1], @board[6, 2])
      # @checks[:white_turn] = !@checks[:white_turn]
      #
      # puts execute_move(@board[4, 5], @board[4, 4])
      # @checks[:white_turn] = !@checks[:white_turn]
      #
      # puts execute_move(@board[5, 3], @board[4, 4])
      # @checks[:white_turn] = !@checks[:white_turn]
      # execute_print_board
    end

    def check_input(from_cell,to_cell,horizontal)
      return (from_cell.length != 2 or to_cell.length != 2 or horizontal.index(from_cell[0]) == nil or horizontal.index(to_cell[0]) == nil or from_cell[1].to_i < 0 or from_cell[1].to_i > 8 or to_cell[1].to_i < 0 or to_cell[1].to_i > 8)
    end

    def split_move(move,char)
      from_cell = move.split(char).first
      to_cell = move.split(char).last
      return from_cell,to_cell
    end

    private def execute_move(square_from, square_to)
      if @board.mate_or_draw?(@checks)
        return false
      end
      !@board.check?(square_from, square_to, @checks)
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

end

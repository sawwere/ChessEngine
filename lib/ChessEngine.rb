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
      #TODO добавить необходимые флаги
      @checks = { white_turn: true, white_castling: true, black_castling: true, draw: false , win: false }
      @board = ChessBoard.new(filename,@checks)
      @history = Array.new
      @board.mate_or_draw?(@checks[:white_turn], @checks)
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

      end
    end

    def positions
      @board.get_positions
    end

    def positions_difference(positions)
      @board.get_positions_difference(positions)
    end

    def checks(check)
      @checks[check]
    end

    def next(move)
      horizontal = 'abcdefgh'
      is_transform = false
      if move == nil or move == ''
        p 'Неправильно введён ход, попробуйте ещё раз'
        return false
      elsif  move == '0-0-0' or move == '0-0'
        #TODO Добавить рокировку
        p 'castling is done'
      elsif move.include? '-'
        is_quiet_move = true
        from_cell,to_cell = split_move(move,'-')
        if to_cell.length == 3 and to_cell[2] == to_cell[2].upcase
          is_transform = true
          transform_to = to_cell[2]
          to_cell = to_cell[0,2]
        end
        if check_input(from_cell,to_cell,horizontal)
          p 'Неправильно введён ход, попробуйте ещё раз'
          return false
        end
        if is_transform
          #TODO Добавить трансофрмирование фигуры
          p 'transform done'
        else
          puts execute_move(@board[horizontal.index(from_cell[0]), 8-from_cell[1].to_i], @board[horizontal.index(to_cell[0]), 8-to_cell[1].to_i])
          p 'quiet_move is done'
        end
      else
        p 'Неправильно введён ход, попробуйте ещё раз'
        return false
      end
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
      if !@board.valid_square?(square_from, @checks[:white_turn]) or
        @board.mate_or_draw?(@checks[:white_turn], @checks) or
        !square_from.get_occupied_by.generate_moves(square_from, @checks).include?(square_to) or
        @board.check?(square_from, square_to, @checks)
        return false
      end
      @board.make_turn(square_from, square_to)
      @checks[:white_turn] = !@checks[:white_turn]
      @board.mate_or_draw?(@checks[:white_turn], @checks)
      true
    end

    def execute_print_board
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

  #game = ChessEngine::ChessMatch.new(nil )
  #game.start

end

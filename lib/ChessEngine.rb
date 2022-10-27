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
      @checks = { white_turn: true, white_castling: true, black_castling: true, draw: false , win: false, passing: nil, last_pas: false }
      @board = ChessBoard.new(filename,@checks)
      @history = Array.new
      @board.mate_or_draw?(@checks[:white_turn], @checks)
    end

    def start
      while true
        puts 'пожалуйста, введите ход'
        input = gets.chomp
        if input == '/exit'
          break
        elsif input == '/print'
          execute_print_board
        elsif input == '/history'
          execute_print_history
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
      figures = 'RBQN'
      is_transform = false
      if move == nil or move == ''
        p 'Неправильно введён ход, попробуйте ещё раз'
        return false
      elsif  move == '0-0-0' or move == '0-0'
        if castling(move.eql?('0-0-0'))
          p 'Рокировка выполнена'
        else
          p 'Невозможно выполнить рокировку'
        end
      elsif move.include? '-'
        is_quiet_move = true
        from_cell,to_cell = split_move(move,'-')
        if from_cell == to_cell
          p 'Неправильно введён ход, попробуйте ещё раз'
          return false
        end
        if to_cell.length == 3 and figures.index(to_cell[2])!= nil
          is_transform = true
          transform_to = to_cell[2]
          to_cell = to_cell[0,2]
        end
        if check_input(from_cell,to_cell,horizontal)
          p 'Неправильно введён ход, попробуйте ещё раз'
          return false
        end
        if is_transform
          return execute_transform_move(@board[horizontal.index(from_cell[0]), 8-from_cell[1].to_i], @board[horizontal.index(to_cell[0]), 8-to_cell[1].to_i], transform_to)
        else
          legal_move=execute_move(@board[horizontal.index(from_cell[0]), 8-from_cell[1].to_i], @board[horizontal.index(to_cell[0]), 8-to_cell[1].to_i])
          if legal_move
            #puts legal_move
            @history.append(move)
          else
            #puts legal_move
            puts "Указаны неверные клетки, повторите ход"
          end
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

    def castling(long)
      if @checks[:white_turn]
        return false unless @checks[:white_castling]
      else
        return false unless @checks[:black_castling]
      end
      short = (long ? 0 : 1)
      white = (@checks[:white_turn] ? 1 : 0)
      k = @board.get_king(@checks[:white_turn])
      return disable_castling if k.get_occupied_by.get_moved
      r = @board[7*short,7*white]
      return disable_castling if r.nil? or r.get_occupied_by.nil? or not FIGURES[r.get_occupied_by.to_s.downcase]=='Rook' or r.get_occupied_by.get_moved
      return false if @board.king_under_attack?(@checks[:white_turn],@checks)
      king = k.get_occupied_by.dup
      rook = r.get_occupied_by.dup
      moves = @board.brave_attack(!@checks[:white_turn],@checks)
      if long
        return false if not @board[1,7*white].get_occupied_by.nil? or not @board[2,7*white].get_occupied_by.nil? or not @board[3,7*white].get_occupied_by.nil?
        return false unless (moves&[@board[1,7*white],@board[2,7*white],@board[3,7*white]]).empty?
        @board[2,7*white].set_occupied_by(king)
        @board[3,7*white].set_occupied_by(rook)
      else
        return false if not @board[5,7*white].get_occupied_by.nil? or not @board[6,7*white].get_occupied_by.nil?
        return false unless (moves&[@board[5,7*white],@board[6,7*white]]).empty?
        @board[6,7*white].set_occupied_by(king)
        @board[5,7*white].set_occupied_by(rook)
      end
      k.set_occupied_by(nil)
      r.set_occupied_by(nil)
      disable_castling
      true
    end
    def disable_castling
      if @checks[:white_turn]
        @checks[:white_castling]=false
      else
        @checks[:black_castling]=false
      end
      false
    end
    private def execute_transform_move(square_from, square_to, transform_to)
      from_fig = square_from.get_occupied_by.dup
      to_fig = square_to.get_occupied_by.dup
      if execute_move(square_from, square_to)
        fig = square_to.get_occupied_by
        if (square_to.get_coordinates[:y] == 0 and fig.white?) or (square_to.get_coordinates[:y] == 7 and !fig.white?)
          square_to.set_occupied_by(ChessEngine::const_get(FIGURES[transform_to.downcase]).new(!@checks[:white_turn],self,true ))
          return true
        end
        @board.make_turn_back(square_from, square_to, from_fig, to_fig)
        false
      end
    end

    def set_passing(square_from, square_to)
      y = square_from.get_coordinates[:y]
      if ((y == 1 and !@checks[:white_turn]) or (y == 6 and @checks[:white_turn])) and square_to.get_occupied_by.to_s.downcase == 'p'
        @checks[:passing] = {from: {x: square_from.get_coordinates[:x], y: square_from.get_coordinates[:y]},
                             to: {x: square_to.get_coordinates[:x], y: square_to.get_coordinates[:y]}}
        @checks[:last_pas] = true
        return true
      end
      @checks[:last_pas] = false
      false
    end

    private def execute_move(square_from, square_to)
      if !@board.valid_square?(square_from, @checks[:white_turn]) or
        @board.mate_or_draw?(@checks[:white_turn], @checks) or
        !square_from.get_occupied_by.generate_moves(square_from, @checks).include?(square_to) or
        @board.check?(square_from, square_to, @checks)
        return false
      end
      dir_y = 1
      dir_y =-1 unless square_from.get_occupied_by.white?
      @board.make_turn(square_from, square_to)
      set_passing(square_from, square_to)
      if !@checks[:last_pas] and
          !@checks[:passing].nil? and
          square_to.get_occupied_by.to_s.downcase == 'p' and
          square_to.get_coordinates[:x] == @checks[:passing][:to][:x] and
          square_to.get_coordinates[:y] == @checks[:passing][:to][:y]-dir_y
        x = @checks[:passing][:to][:x]
        y = @checks[:passing][:to][:y]
        @board[x, y].set_occupied_by(nil)
        @checks[:passing] = nil

      end
      @checks[:white_turn] = !@checks[:white_turn]
      @board.mate_or_draw?(@checks[:white_turn], @checks)
      #@history.append({from:square_from, to: square_to})
      true
    end

    def execute_print_board
      @board.print_board
    end

    private def execute_print_history
      @history.each_index  {|x| puts (x+1).to_s+" "+@history[x]}
    end

    private def execute_save(filename)
      @board.save_board(filename)
    end
  end

  game = ChessEngine::ChessMatch.new(nil )
  game.start

end

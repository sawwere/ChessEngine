require 'square'
require 'figure'
require 'set'

module ChessEngine
  BOARD_SIZE = 8
  START_POSITIONS= %w[rnbqkbnr
                      pppppppp
                      ........
                      ........
                      ........
                      ........
                      PPPPPPPP
                      RNBQKBNR]
  class ChessBoard
    def initialize(filename, checks=nil)
      @checks=checks
      create_board(BOARD_SIZE)
      load_board(filename) unless filename.nil? or not File.file?(filename)
      init_figures(START_POSITIONS) if filename.nil? or not File.file?(filename)
    end
    def string_to_bool(str)
      true if str=='true'
      false if str=='false'
    end
    #Load board data from file
    def load_board(filename)
      File.open(filename, 'r') do |file|
        lines=Array.new
        (0..BOARD_SIZE-1).each { lines.push(file.readline(chomp: true)) }
        init_figures(lines)
        return if @checks.nil?
        lines=file.readlines(chomp: true)
        lines.each do |line|
          case line.split(' = ').first
          when 'white_turn'
            b=string_to_bool(line.split(' = ').last)
            @checks[:white_turn] = b unless b.nil?
          when 'white_castling'
            b=string_to_bool(line.split(' = ').last)
            @checks[:white_castling] = b unless b.nil?
          when 'black_castling'
            b=string_to_bool(line.split(' = ').last)
            @checks[:black_castling] = b unless b.nil?
          else
            # type code here
          end
        end
      end
    end

    #Save board data to file
    def save_board(filename)
      File.open(filename, 'w') do |file|
        @squares.each do |row|
          line=''
          row.each  do |sq|
            line+="\u25A1".encode('utf-8') if sq.get_occupied_by.nil?
            line+=sq.get_occupied_by.to_s unless sq.get_occupied_by.nil?
          end
          file.write(line,"\n")
        end
        return if @checks.nil?
        file.write("white_turn = #{@checks[:white_turn].to_s}","\n") unless @checks[:white_turn]
        file.write("white_castling = #{@checks[:white_castling].to_s}","\n") unless @checks[:white_castling]
        file.write("black_castling = #{@checks[:black_castling].to_s}","\n") unless @checks[:black_castling]
        file.write("last_turn = #{@checks[:last_turn].to_s}","\n") unless @checks[:last_turn].eql?('')
      end
    end

    #Add figures to board at starting position
    def init_figures(lines)
      lines.each_with_index do |line, i|
        (0..BOARD_SIZE-1).each { |j|
          color = line[j].eql?(line[j].to_s.upcase)
          moved = !line[j].eql?(START_POSITIONS[i][j])
          fg = FIGURES[line[j].to_s.downcase]
          @squares[i][j].set_occupied_by(ChessEngine::const_get(fg).new(color,self,moved)) unless fg.nil?
        }
      end
    end

    #Remove all figures from board
    def clear_board
      @squares.each  do |row|
        row.each  do |sq|
          p sq.set_occupied_by(nil)
        end
      end
    end

    #Create empty chess board with white/black squares
    def create_board(size)
      @squares = Array.new(size) { Array.new(size) }
      @squares.each_with_index  do |row,row_i|
        row.each_index  do |col_i|
          @squares[row_i][col_i] = Square.new(nil, {y: row_i, x: col_i})
        end
      end
    end
    def get_positions
      lines = Array.new
      @squares.each_with_index do |row|
        s=''
        row.each  do |sq|
          s+=sq.get_symbol
        end
        lines.push(s)
      end
      lines
    end
    def get_positions_difference(positions)
      res=Hash.new
      (0..BOARD_SIZE-1).each do |y|
        (0..BOARD_SIZE-1).each do |x|
          res["#{('a'.ord+x).chr}#{8-y}"]=@squares[y][x].get_symbol unless positions[y][x].eql?(@squares[y][x].get_symbol)
        end
      end
      res
    end
    def print_board
      @squares.each_with_index do |row, row_i|
        row.each  do |sq|
          sq.print_square
        end
        puts "| #{8-row_i}"
      end
      puts ' -  -  -  -  -  -  -  -  ',' a  b  c  d  e  f  g  h '
    end

    # Cycle through the board checking squares
    def get_accessible_squares(dir_y, dir_x, x0, y0, distance)
      res = Set.new
      dx = dir_x
      dy = dir_y
      while dx.abs <= distance and
          dy.abs <= distance and
          x0 - dx >= 0 and
          x0 - dx <= BOARD_SIZE - 1 and
          y0 - dy >= 0 and
          y0 - dy <= BOARD_SIZE - 1

        unless @squares[y0 - dy][x0 - dx].get_occupied_by.nil?
          if @squares[y0 - dy][x0 - dx].get_occupied_by.white? != @squares[y0][x0].get_occupied_by.white?
            res = res.add(@squares[y0 - dy][x0 - dx])
          end
          break
        end
        res = res.add(@squares[y0 - dy][x0 - dx])
        dx += dir_x
        dy += dir_y
      end
      res
    end

    # Return set of squares which can be accessed from the square horizontally within distance
    def generate_horizontal(square, distance)
      res = Set.new
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      res.union(get_accessible_squares(0, 1, x0, y0, distance)).
                      union(get_accessible_squares(0, -1, x0, y0, distance))
    end

    # Return set of squares which can be accessed from the square vertically within distance
    def generate_vertical_up(square, distance)
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      get_accessible_squares(1, 0, x0, y0, distance)
    end

    def generate_vertical_down(square, distance)
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      get_accessible_squares(-1, 0, x0, y0, distance)
    end

    def generate_diagonal(square, distance)
      res = Set.new
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      res.union(get_accessible_squares(1, 1, x0, y0, distance)).
                      union(get_accessible_squares(1, -1, x0, y0, distance)).
                      union(get_accessible_squares(-1, 1, x0, y0, distance)).
                      union(get_accessible_squares(-1, -1, x0, y0, distance))
    end

    def angle(x0, y0, dx, dy)
      x_border = dx > 0 ? 8 - x0 : x0 - 1
      y_border = dy > 0 ? 8 - y0 : y0 - 1
      if (((dx > 0) and (x0 > x_border)) or ((dx < 0) and (x0 < x_border))) and
        (((dy > 0) and (y0 > y_border)) or ((dy < 0) and (y0 < y_border))) and
        @squares[y0+dy][x0+dx].get_occupied_by.white? != @squares[y0][x0].get_occupied_by.white?
      end
    end

    def generate_angular(square)
      res = Set.new
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      res = res.union(angle(x0, y0, -2,  1)).
        union(angle(x0, y0, 2,   1)).
        union(angle(x0, y0, -1,  2)).
        union(angle(x0, y0, 1,   2)).
        union(angle(x0, y0, -2, -1)).
        union(angle(x0, y0, 2,  -1)).
        union(angle(x0, y0, -1, -2)).
        union(angle(x0, y0, 1,  -2))

      res
    end

    def [](x, y)
      if x>=0 and x<BOARD_SIZE and y>=0 and y<BOARD_SIZE
        return  @squares[y][x]
      end
      raise IndexError
    end

    def get_king(color)
      @squares.each  do |row|
        row.each  do |sq|
          if !sq.get_occupied_by.nil? and sq.get_occupied_by.white? == color and sq.get_occupied_by.to_s.upcase == 'K'
            return sq
          end
        end
      end
    end

    #Возвращает все возможные ходы всех фигур цвета color
    def get_all_moves(color, checks)
      res = Set.new
      figs_f = Set.new
      @squares.each_with_index  do |row,row_i|
        row.each_index  do |col_i|
          fg=@squares[row_i][col_i].get_occupied_by
          figs_f.add(@squares[row_i][col_i]) if not fg.nil? and fg.white? == color
        end
      end
      figs_f.each  do |sq|
        potential = sq.get_occupied_by.generate_moves(sq, checks)
        potential.each do |pp|
          unless check?(sq, pp, checks)
            res = res.add(sq)
          end
        end
      end
      res
    end

    private def brave_attack(color, checks)
      res = Set.new
      @squares.each  do |row|
        row.each  do |sq|
          if !sq.get_occupied_by.nil? and sq.get_occupied_by.white? == color
            res = res.union(sq.get_occupied_by.generate_moves(sq, checks))
          end
        end
      end
      res
    end

    def king_under_attack?(color, checks)
      king_square = get_king(checks[:white_turn])
      enemy_attack = brave_attack(!checks[:white_turn], checks)
      enemy_attack.include?(king_square)
    end

    def valid_square?(square_from, color)
      !square_from.get_occupied_by.nil? and square_from.get_occupied_by.white? == color
    end

    #
    def mate_or_draw?(color, checks)
      if get_all_moves(checks[:white_turn], checks).size == 0
        if !king_under_attack?(color, checks)
          checks[:draw] = true
          puts "Ничья"
        else
          puts "Мат" + (checks[:white_turn] ? "белым" : "черным")
          checks[:win] = true
        end
        return true
      end
      false
    end

    # Move piece from square_from to square_to
    def make_turn(square_from, square_to)
      to = square_to.get_coordinates
      from = square_from.get_coordinates
      @squares[to[:y]][to[:x]].set_occupied_by(square_from.get_occupied_by.dup )
      @squares[from[:y]][from[:x]].set_occupied_by(nil)
    end

    private def make_turn_back(square_from, square_to, from_fig, to_fig)
      to = square_to.get_coordinates
      from = square_from.get_coordinates
      @squares[to[:y]][to[:x]].set_occupied_by(to_fig )
      @squares[from[:y]][from[:x]].set_occupied_by(from_fig)
    end

    # Will moving from square_from to square_to lead to check
    def check?(square_from, square_to, checks)
      from_fig = square_from.get_occupied_by.dup
      to_fig = square_to.get_occupied_by.dup
      make_turn(square_from, square_to)
      if king_under_attack?(checks[:white_turn], checks)
        make_turn_back(square_from, square_to, from_fig, to_fig)
        return true
      end
      make_turn_back(square_from, square_to, from_fig, to_fig)
      false
      end
  end
end

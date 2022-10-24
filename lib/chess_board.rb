require 'square'
require 'figure'
require 'set'

module ChessEngine
  class ChessBoard
    SIZE = 8
    def initialize(filename)
      #s = Square.new(Colors::WHITE, nil, nil)
      #p s
      @white_turn=true
      @white_castling=true
      @black_castling=true
      create_board(SIZE)
      load_board(filename) unless filename.nil?
      init_figures if filename.nil?
    end

    #Load board data from file
    def load_board(filename)
      File.open(filename, 'r') do |file|
        (0..SIZE-1).each { |i|
          line=file.readline(chomp: true)
          (0..SIZE-1).each { |j|
            color = true ? line[j]==line[j].to_s.upcase : false
            fg = FIGURES[line[j].to_s.downcase]
            @squares[i][j].set_occupied_by(ChessEngine::const_get(fg).new(color)) unless fg.nil?
          }
        }
        line=file.readline(chomp: true)
        if line=='true'
          @white_turn=true
        elsif line=='false'
          @white_turn=false
        else
          raise 'Error reading file!'
        end
        line=file.readline(chomp: true)
        if line=='true'
          @white_castling=true
        elsif line=='false'
          @white_castling=false
        else
          raise 'Error reading file!'
        end
        line=file.readline(chomp: true)
        if line=='true'
          @black_castling=true
        elsif line=='false'
          @black_castling=false
        else
          raise 'Error reading file!'
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
        file.write(@white_turn.to_s,"\n")
        file.write(@white_castling.to_s,"\n")
        file.write(@black_castling.to_s,"\n")
      end
    end

    #Add figures to board at starting position
    def init_figures
      #Black player
      @squares[0][0].set_occupied_by(Rook.new(false))
      @squares[0][1].set_occupied_by(Knight.new(false))
      @squares[0][2].set_occupied_by(Bishop.new(false))
      @squares[0][3].set_occupied_by(Queen.new(false))
      @squares[0][4].set_occupied_by(King.new(false))
      @squares[0][5].set_occupied_by(Bishop.new(false))
      @squares[0][6].set_occupied_by(Knight.new(false))
      @squares[0][7].set_occupied_by(Rook.new(false))
      #Pawns
      @squares[1].each { |sq| sq.set_occupied_by(Pawn.new(false))}
      #White player
      @squares[7][0].set_occupied_by(Rook.new(true))
      @squares[7][1].set_occupied_by(Knight.new(true))
      @squares[7][2].set_occupied_by(Bishop.new(true))
      @squares[7][3].set_occupied_by(Queen.new(true))
      @squares[7][4].set_occupied_by(King.new(true))
      @squares[7][5].set_occupied_by(Bishop.new(true))
      @squares[7][6].set_occupied_by(Knight.new(true))
      @squares[7][7].set_occupied_by(Rook.new(true))
      #Pawns
      @squares[6].each { |sq| sq.set_occupied_by(Pawn.new(true))}
    end

    def get_square(coords)
      case coords
      when Array
        x,y = coords
      when Hash
        x,y = coords.values
      else
        return nil
      end
      if x>=0 and x<SIZE and y>=0 and y<SIZE
        @squares[y][x]
      else
        nil
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

    def print_board
      @squares.each  do |row|
        row.each  do |sq|
          sq.print_square
        end
        puts
      end
    end

    # Cycle through the board checking squares
    def get_accessible_squares(dir_y, dir_x, y0, x0, distance)
      res = Set.new
      dx = dir_x
      dy = dir_y
      while dx.abs <= distance and
          dy.abs <= distance and
          x0 - dx >= 0 and
          x0 - dx <= SIZE - 1 and
          y0 - dy >= 0 and
          y0 - dy <= SIZE - 1

        unless @squares[y0 - dy][x0 - dx].get_occupied_by.nil?
          if @squares[y0 - dy][x0 - dx].get_occupied_by.white? != @squares[y0][x0].get_occupied_by.white?
            res.add(@squares[y0 - dy][x0 - dx])
          end
          break
        end
        res.add(@squares[y0 - dy][x0 - dx])
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
    def generate_vertical(square, distance)
      res = Set.new
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      res.union(get_accessible_squares(1, 0, x0, y0, distance)).
                      union(get_accessible_squares(-1, 0, x0, y0, distance))
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
  end
end

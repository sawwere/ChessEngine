require 'square'
require 'figure'
require 'set'

module ChessEngine
  class ChessBoard
    SIZE = 8

    def initialize(filename)
      #s = Square.new(Colors::WHITE, nil, nil)
      #p s
      create_board(SIZE)
      load_board(filename) unless filename.nil?
      init_figures if filename.nil?
    end

    #Load board data from file
    def load_board(filename)
      #TODO
    end

    #Save board data to file
    def save_board(filename)
      #TODO
    end

    #Add figures to board at starting position
    def init_figures
      #Black player
      @squares[0][0].set_occupied_by(Figure.new('Rook','B'))
      @squares[0][1].set_occupied_by(Figure.new('Knight','B'))
      @squares[0][2].set_occupied_by(Figure.new('Bishop','B'))
      @squares[0][3].set_occupied_by(Figure.new('Queen','B'))
      @squares[0][4].set_occupied_by(Figure.new('King','B'))
      @squares[0][5].set_occupied_by(Figure.new('Bishop','B'))
      @squares[0][6].set_occupied_by(Figure.new('Knight','B'))
      @squares[0][7].set_occupied_by(Figure.new('Rook','B'))
      #Pawns
      @squares[1].each { |sq| sq.set_occupied_by(Figure.new('Pawn','B'))}
      #White player
      @squares[7][0].set_occupied_by(Figure.new('Rook','W'))
      @squares[7][1].set_occupied_by(Figure.new('Knight','W'))
      @squares[7][2].set_occupied_by(Figure.new('Bishop','W'))
      @squares[7][3].set_occupied_by(Figure.new('Queen','W'))
      @squares[7][4].set_occupied_by(Figure.new('King','W'))
      @squares[7][5].set_occupied_by(Figure.new('Bishop','W'))
      @squares[7][6].set_occupied_by(Figure.new('Knight','W'))
      @squares[7][7].set_occupied_by(Figure.new('Rook','W'))
      #Pawns
      @squares[6].each { |sq| sq.set_occupied_by(Figure.new('Pawn','W'))}
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
        row.each_with_index  do |sq, col_i|
          #p sq
          if (row_i+col_i)%2==0
            color = Colors::WHITE
          else
            color = Colors::BLACK
          end
          @squares[row_i][col_i] = Square.new(color, nil, {y: row_i, x: col_i})
        end
      end
    end

    def print_board
      @squares.each  do |row|
        row.each  do |sq|
          sq.print_square
        end
      end
    end

    # Cycle through the board checking squares
    def get_accessible_squares(dir_y, dir_x, y0, x0, distance)
      res = Set.new
      dx = dir_x
      dy = dir_y
      while dir_x.abs < distance and
          x0 - dx >= 0 and
          x0 - dx <= SIZE - 1 and
          y0 - dy >= 0 and
          y0 - dy <= SIZE - 1 and
          @squares[y0 - dy][x0 - dx].get_occupied_by.nil?
        res.add(@squares[y0 - dy][x0 - dx])
        dx += dir_x
        dy += dir_y
      end
      return res
    end

    # Return set of squares which can be accessed from the square horizontally within distance
    def generate_horizontal(square, distance)
      res = Set.new
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      res = res.union(get_accessible_squares(0, 1, x0, y0, distance)).
                union(get_accessible_squares(0, -1, x0, y0, distance))
      return res
    end

    # Return set of squares which can be accessed from the square vertically within distance
    def generate_vertical(square, distance)
      res = Set.new
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      res = res.union(get_accessible_squares(1, 0, x0, y0, distance)).
                union(get_accessible_squares(-1, 0, x0, y0, distance))
      return res
    end

    def generate_diagonal(square, distance)
      res = Set.new
      x0 = square.get_coordinates[:x]
      y0 = square.get_coordinates[:y]
      res = res.union(get_accessible_squares(1, 1, x0, y0, distance)).
                union(get_accessible_squares(1, -1, x0, y0, distance)).
                union(get_accessible_squares(-1, 1, x0, y0, distance)).
                union(get_accessible_squares(-1, -1, x0, y0, distance))
      return res
    end
  end
end

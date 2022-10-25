require 'square'

module ChessEngine
  FIGURES={'p'=>'Pawn','n'=>'Knight', 'r'=>'Rook','q'=>'Queen','k'=>'King','b'=>'Bishop'}
  class Figure
    def initialize(white, board, moved=true)
      @moved = moved
      @white = white
      @name = FIGURES.key(self.class.name.split('::').last).dup
      @name.upcase! if @white
      @board = board
    end

    def white?
      @white
    end

    def set_moved(b)
      @moved=b
    end
    def get_moved
      @moved
    end

    def generate_moves(coordinates, checks)
      #TODO переопределить для всех фигур
      return Set.new
    end

    def to_s
      @name
    end
  end

  class Rook < Figure
    def initialize(white, board, moved=true)
      super
    end
  end

  class Knight < Figure
    def initialize(white, board, moved=true)
      super
    end
    # def generate_moves(coordinates, checks)
    #   if coordinates.has_key?('x') and coordinates.has_key?('y') and checks.has_key?('white_turn') and checks.has_key?('white_castling') and checks.has_key?('black_castling') and next_square.has_key?('x') and next_square.has_key?('y')
    #     if checks[:white_turn] and !checks[:white_castling]
    #       #FIXME Проект не запускается из-за этой строчки!
    #       #return (Math.abs(coordinates[:x]-next_square[:x])==1 and(Math.abs(coordinates[:y]-next_square[:y])==2))or(Math.abs(coordinates[:x]-next_square[:x])==2 and ((Math.abs(coordinates[:y]-next_square[:y])==1)))
    #     else
    #
    #     end
    #   else
    #   end
    # end
  end
  class Bishop < Figure
    def initialize(white, board, moved=true)
      super
    end
  end

  class Queen < Figure
    def initialize(white, board, moved=true)
      super
    end
  end

  class King < Figure
    def initialize(white, board, moved=true)
      super
    end
  end

  class Pawn < Figure
    def initialize(white, board, moved=true)
      super
    end

    def generate_moves(init_square, checks)
      return @board.generate_horizontal(init_square, 2).
        union(@board.generate_vertical_up(init_square, 2)).
        union(@board.generate_vertical_down(init_square, 2)).
        union( @board.generate_diagonal(init_square, 2))
    end
  end
end

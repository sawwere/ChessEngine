require 'square'

module ChessEngine
  #FIGURES_WHITE={'♙'=>'Pawn','♘'=>'Knight', '♖'=>'Rook','♕'=>'Queen','♔'=>'King','♗'=>'Bishop'}
  #FIGURES_BLACK={'♟'=>'Pawn','♞'=>'Knight', '♜'=>'Rook','♛'=>'Queen','♚'=>'King','♝'=>'Bishop'}
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

    def generate_moves(init_square, checks)
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
    def generate_moves(init_square, checks)
      return @board.generate_angular(init_square)

    end
  end
  class Bishop < Figure
    def initialize(white, board, moved=true)
      super
    end

    def generate_moves(init_square, checks)
      return @board.generate_horizontal(init_square, 8).
        union(@board.generate_vertical_up(init_square, 8)).
        union(@board.generate_vertical_down(init_square, 8)).
        union( @board.generate_diagonal(init_square, 8))
    end
  end

  class Queen < Figure
    def initialize(white, board, moved=true)
      super
    end
    def generate_moves(init_square,  checks)
    moves = @board.generate_horizontal(init_square, 8).
      union(@board.generate_vertical_up(init_square, 8)).
      union(@board.generate_vertical_down(init_square, 8)).
      union( @board.generate_diagonal(init_square, 8))

    return  moves
    end

  end

  class King < Figure
    def initialize(white, board, moved=true)
      super
    end

    def generate_moves(init_square, checks)
        moves = @board.generate_horizontal(init_square, 1).
        union(@board.generate_vertical_up(init_square, 1)).
        union(@board.generate_vertical_down(init_square, 1)).
        union( @board.generate_diagonal(init_square, 1))

        moves
    end

    def castling(init_square_king,init_square_rook)
      moves1=@board.get_all_moves(not(@white))
      moves2=@board.generate_horizontal(init_square_rook, 8)
      moves2.each do |i|
        if moves1.include?(moves2[i])
          return false
        end
      end
      return  true
   end
  end

  class Pawn < Figure
    def initialize(white, board, moved=true)
      super
    end

    def generate_moves(init_square, checks)
      if (@white)
        if (@moved!=true)

        moves = @board.generate_vertical_up(init_square, 2).
        union( @board.generate_diagonal(init_square, 1))
        else
        moves = @board.generate_vertical_up(init_square, 1).
        union( @board.generate_diagonal(init_square, 1))
        end
      else
        if (@moved!=true)
          moves = @board.generate_vertical_down(init_square, 2).
            union( @board.generate_diagonal(init_square, 1))
        else
          moves = @board.generate_vertical_down(init_square, 1).
            union( @board.generate_diagonal(init_square, 1))
        end
      end
      return moves
    end
  end

end

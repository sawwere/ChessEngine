require 'square'

module ChessEngine
  FIGURES={'p'=>'Pawn','n'=>'Knight', 'r'=>'Rook','q'=>'Queen','k'=>'King','b'=>'Bishop'}
  class Figure
    def initialize(white)
      @moved = false
      @white = white
      @name = FIGURES.key(self.class.name.split('::').last).dup
      @name.upcase! if @white
    end

    def white?
      @white
    end

    def generate_moves(coordinates, checks)
      #TODO переопределить для всех фигур
    end

    def to_s
      @name
    end
  end

  class Rook < Figure
    def initialize(white)
      super
    end
  end

  class Knight < Figure
    def initialize(white)
      super
    end
  end

  class Bishop < Figure
    def initialize(white)
      super
    end
  end

  class Queen < Figure
    def initialize(white)
      super
    end
  end

  class King < Figure
    def initialize(white)
      super
    end
  end

  class Pawn < Figure
    def initialize(white)
      super
    end
  end
end

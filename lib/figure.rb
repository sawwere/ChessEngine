require 'square'

module ChessEngine
  class Figure
    def initialize(white)
      @moved = false
      @white = white
      @name.upcase! if @white
    end
    def white?
      @white
    end
    def move(coordinates)
      #TODO переопределить для всех фигур
    end

    def to_s
      @name
    end
  end

  class Rook < Figure
    def initialize(white)
      @name='r'
      super
    end
  end

  class Knight < Figure
    def initialize(white)
      @name='n'
      super
    end
  end

  class Bishop < Figure
    def initialize(white)
      @name='b'
      super
    end
  end

  class Queen < Figure
    def initialize(white)
      @name='q'
      super
    end
  end

  class King < Figure
    def initialize(white)
      @name='k'
      super
    end
  end

  class Pawn < Figure
    def initialize(white)
      @name='p'
      super
    end
  end
end

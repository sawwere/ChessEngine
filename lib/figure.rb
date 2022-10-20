require 'square'

module ChessEngine
  class Figure
    def initialize(name, color)
      @name = name
      @color = color
    end

    def get_color
      return @color
    end

    def move(coordinates)
      #TODO переопределить для всех фигур
    end

    def to_s
      @color == 'W' ? self.class.name.split('::').last[0].upcase : self.class.name.split('::').last[0].downcase
    end
  end

  class Rook < Figure

  end

  class Knight < Figure

  end

  class Bishop < Figure

  end

  class Queen < Figure

  end

  class King < Figure

  end

  class Pawn < Figure

  end
end

require 'figure'

module Colors
  WHITE = 0
  BLACK = 1
end

module ChessEngine
  class Square
    def initialize(color, occupied_by, coordinates)
      @color = color
      @occupied_by = occupied_by
      @coordinates = coordinates
    end

    def get_color
      return  @color
    end

    def get_occupied_by
      return @occupied_by
    end

    def set_occupied_by(figure)
      @occupied_by = figure
    end

    def get_coordinates
      return @coordinates
    end

    def test(a)
      p @color, @occupied_by, @coordinates
    end
  end
end

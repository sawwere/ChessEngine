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

    def print_square
      print !@occupied_by.nil? ? @occupied_by : "\u25A1".encode('utf-8')
    end
  end
end

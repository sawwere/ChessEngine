require 'figure'

module ChessEngine
  class Square
    def initialize(occupied_by, coordinates)
      @occupied_by = occupied_by
      @coordinates = coordinates
    end

    def get_occupied_by
      @occupied_by
    end

    def set_occupied_by(figure)
      @occupied_by = figure
    end

    def get_coordinates
      @coordinates
    end

    def print_square
      print !@occupied_by.nil? ? @occupied_by.to_s : "\u25A1".encode('utf-8')
    end
  end
end

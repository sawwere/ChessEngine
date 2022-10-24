
def read_move(string,move_number)
  move = string.split('.').last
  if  move.include? '0'
    #call methods for castling
    p 'castling is done'
    return move_number, move
  elsif move.include? '-'
    is_quiet_move = true
    from_cell,to_cell = split_move(move,'-')
    if to_cell[-1,1] = to_cell[-1,1].upcase
      transformation_figure = to_cell[-1,1]
    end
    #call methods for quiet_move
    p 'quiet_move is done'
    return move_number, move, from_cell, to_cell
  elsif move.include? 'x'
    is_quiet_move = false
    from_cell,to_cell = split_move(move,'x')
    #call methods for not quiet_move
    p 'not quiet_move is done'
    return move_number, move, from_cell, to_cell
  else
    p 'incorrect input'
  end
end

def split_move(move,char)
  from_cell = move.split(char).first
  to_cell = move.split(char).last
  return from_cell,to_cell
end

def read_notation(notation)
  white_move = notation.split(' ').first
  move_number = white_move.split('.').first
  black_move = notation.split(' ').last
  p read_move(white_move,move_number)
  p read_move(black_move,move_number)
end

#p read_move('1.e2-e4')
#p read_move('3.0-0-0')
#p read_move('4.0-0')
 read_notation('1.e2-e4 e7-e5')


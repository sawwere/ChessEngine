# frozen_string_literal: true

require "./test/test_helper"

class TestChessEngine < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ChessEngine::VERSION
  end
  def test_input
    game=ChessEngine::ChessMatch.new(nil)
    assert(game.next('e2-e3'))
  end
  def test_input_incorrect1
    game=ChessEngine::ChessMatch.new(nil)
    assert(not(game.next('')))
  end
  def test_input_incorrect2
    game=ChessEngine::ChessMatch.new(nil)
    assert(not(game.next('blabla')))
  end
  def test_move_enemy_piece
    game=ChessEngine::ChessMatch.new(nil)
    old_positions=game.positions
    game.next('b7-b6')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_move_outside_board
    game=ChessEngine::ChessMatch.new(nil)
    old_positions=game.positions
    game.next('g8-f10')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_checkmate
    game = ChessEngine::ChessMatch.new('test/boards/test_checkmate.txt')
    game.next('h3-h8')
    assert game.checks(:win)
  end
  def test_draw
    game = ChessEngine::ChessMatch.new('test/boards/test_draw.txt')
    assert(game.checks(:draw))
  end
end
class TestCastling < Minitest::Test
  def test_short
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling.txt')
    old_positions=game.positions
    game.next('0-0')
    assert_equal(game.positions_difference(old_positions),{'e1'=>'.','h1'=>'.','f1'=>'R','g1'=>'K'})
  end
  def test_long
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling.txt')
    old_positions=game.positions
    game.next('0-0-0')
    assert_equal(game.positions_difference(old_positions),{'e1'=>'.','a1'=>'.','d1'=>'R','c1'=>'K'})
  end
  def test_attack_between_1
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_attack_between.txt')
    old_positions=game.positions
    game.next('0-0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack_between_2
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_attack_between.txt')
    old_positions=game.positions
    game.next('0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_king_moved_1
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_king_moved.txt')
    old_positions=game.positions
    game.next('0-0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_king_moved_2
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_king_moved.txt')
    old_positions=game.positions
    game.next('0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_check_1
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_check.txt')
    old_positions=game.positions
    game.next('0-0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_check_2
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_check.txt')
    old_positions=game.positions
    game.next('0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_piece_between_1
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_piece_between.txt')
    old_positions=game.positions
    game.next('0-0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_piece_between_2
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_piece_between.txt')
    old_positions=game.positions
    game.next('0-0')
    assert_equal(game.positions_difference(old_positions),{'e1'=>'.','g1'=>'K','h1'=>'.','f1'=>'R'})
  end
  def test_rook_destroyed
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_rook_moved_or_destroyed.txt')
    old_positions=game.positions
    game.next('0-0')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_rook_moved
    game = ChessEngine::ChessMatch.new('test/boards/castling/test_castling_rook_moved_or_destroyed.txt')
    old_positions=game.positions
    game.next('0-0-0')
    assert_empty(game.positions_difference(old_positions))
  end
end
class TestPawn < Minitest::Test
  def test_transformation
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a7-a8Q')
    game.execute_print_board
    p game.positions_difference(old_positions)
    assert_equal(game.positions_difference(old_positions),{"a8"=>"Q", "a7"=>"."})
  end
  def test_passent
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.execute_print_board
    game.next('d2-d4')
    game.execute_print_board
    game.next('e4-d3')
    game.execute_print_board
    assert_equal(game.positions_difference(old_positions),{'d2'=>'.','e4'=>'.','d3'=>'p'})
  end
  def test_move_to_one
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a3-a4')
    assert_equal(game.positions_difference(old_positions),{'a3'=>'.','a4'=>'P'})
  end
  def test_move_to_two
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('d2-d4')
    assert_equal(game.positions_difference(old_positions),{'d2'=>'.','d4'=>'P'})
  end
  def test_move_to_two_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a3-a5')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_move_through_piece
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a2-a4')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a3-b4')
    assert_equal(game.positions_difference(old_positions),{'a3'=>'.','b4'=>'P'})
  end
  def test_move_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a3-a2')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack_incorrect_1
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a2-a3')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack_incorrect_2
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('d2-d3')
    game.next('d5-e4')
    assert_equal(game.positions_difference(old_positions),{'d2'=>'.','d3'=>'P'})
  end
  def test_passent_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_pawns.txt')
    old_positions=game.positions
    game.next('a3-a4')
    game.next('b4-a3')
    game.execute_print_board
    assert_equal(game.positions_difference(old_positions), {"a4"=>"P", "a3"=>"."})
  end
end
class TestKnight < Minitest::Test
  def test_move1
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-e6')
    assert_equal(game.positions_difference(old_positions),{'f4'=>'.','e6'=>'N'})
  end
  def test_move2
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-h5')
    assert_equal(game.positions_difference(old_positions),{'f4'=>'.','h5'=>'N'})
  end
  def test_move3
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-d3')
    assert_equal(game.positions_difference(old_positions),{'f4'=>'.','d3'=>'N'})
  end
  def test_move_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-d4')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack1
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-d5')
    assert_equal(game.positions_difference(old_positions),{'f4'=>'.','d5'=>'N'})
  end
  def test_attack2
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-g6')
    assert_equal(game.positions_difference(old_positions),{'f4'=>'.','g6'=>'N'})
  end
  def test_attack3
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-e2')
    assert_equal(game.positions_difference(old_positions),{'f4'=>'.','e2'=>'N'})
  end
  def test_attack_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('f4-h3')
    assert_empty(game.positions_difference(old_positions))
  end
end
class TestBishop < Minitest::Test
  def test_move1
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e5-b8')
    assert_equal(game.positions_difference(old_positions),{'e5'=>'.','b8'=>'B'})
  end
  def test_move2
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e5-h8')
    assert_equal(game.positions_difference(old_positions),{'e5'=>'.','h8'=>'B'})
  end
  def test_move_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e5-f5')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_move_through_piece
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e5-g3')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e5-c3')
    assert_equal(game.positions_difference(old_positions),{'e5'=>'.','c3'=>'B'})
  end
  def test_attack_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e5-f4')
    assert_empty(game.positions_difference(old_positions))
  end
end
class TestQueen < Minitest::Test
  def test_move1
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('d1-b1')
    assert_equal(game.positions_difference(old_positions),{'d1'=>'.','b1'=>'Q'})
  end
  def test_move2
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('d1-b3')
    assert_equal(game.positions_difference(old_positions),{'d1'=>'.','b3'=>'Q'})
  end
  def test_move_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('d1-a2')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_move_through_piece
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('d1-f3')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('d1-a4')
    assert_equal(game.positions_difference(old_positions),{'d1'=>'.','a4'=>'Q'})
  end
  def test_attack_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('d1-d2')
    assert_empty(game.positions_difference(old_positions))
  end
end
class TestRook < Minitest::Test
  def test_move
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('a1-a3')
    assert_equal(game.positions_difference(old_positions),{'a1'=>'.','a3'=>'R'})
  end
  def test_move_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('h3-g4')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_move_through_piece
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('a1-a5')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('h3-c3')
    assert_equal(game.positions_difference(old_positions),{'h3'=>'.','c3'=>'R'})
  end
  def test_attack_incorrect
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('a1-d1')
    assert_empty(game.positions_difference(old_positions))
  end
end
class TestKing < Minitest::Test
  def test_move
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e1-f2')
    assert_equal(game.positions_difference(old_positions),{'e1'=>'.','f2'=>'K'})
  end
  def test_move_incorrect1
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e1-f1')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_move_incorrect2
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e1-h4')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e1-e2')
    assert_equal(game.positions_difference(old_positions),{'e1'=>'.','e2'=>'K'})
  end
  def test_attack_incorrect1
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e1-d1')
    assert_empty(game.positions_difference(old_positions))
  end
  def test_attack_incorrect2
    game = ChessEngine::ChessMatch.new('test/boards/test_moves.txt')
    old_positions=game.positions
    game.next('e1-c3')
    assert_empty(game.positions_difference(old_positions))
  end
end
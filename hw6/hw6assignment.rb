# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  
  # Override of next_piece method to use new pieces
  def self.next_piece(board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  def self.cheat_piece(board)
    MyPiece.new(Cheat_Piece, board)
  end

  # class array adding some pieces to All Pieces

  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
                   # !!!
                   # !!!
                   # rotations([[0, 0], [1, 0], [0, 1]]), # stubby L
                   rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
                   [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
                    [[0, 0], [0, -1], [0, 1], [0, 2]]],
                   rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
                   rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
                   rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
                   rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
                   rotations([[0, 0], [1, 0], [0, 1], [-1, 0], [-1, 1]]), #CorneredT
                   [[[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]], # very long 
                    [[0, -2], [0, -1], [0, 0], [0, 1], [0, 2]]],
                  ]  
  Cheat_Piece = [[0, 0]]
end

class MyBoard < Board
  # your enhancements here

  def initialize (game)
    super
    @cheat = false
  end
  
  def cheat
    @cheat
  end

  def cheat=(state)
    @cheat = state
  end

  def rotate_180
      if !game_over? and @game.is_running?
        @current_block.move(0, 0, 2)
      end
      draw
  end

  # Override Board's next_piece to use MyPiece
  def next_piece
    if cheat and (@score > 100)
    then ( @score -= 100
           @cheat = false
           @current_block = MyPiece.cheat_piece(self)
           @current_pos = nil)
    else
      ( @current_block = MyPiece.next_piece(self)
        @current_pos = nil)
    end
  end
end

class MyTetris < Tetris
  # your enhancements here

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
  
  def key_bindings
    super
    @root.bind('u', proc {@board.rotate_180})
    @root.bind('c', proc {@board.cheat = true})
  end
end



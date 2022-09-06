class Board < ApplicationRecord
  after_initialize :new_board

  def to_s
    output = " abcdefgh\n"
    board = (0..7).map do |row|
      # puts row
      # puts self.board[row]
      "#{row+1}#{self.board[row].map{|p| p.nil? ? ' ' : p}.join}"
    end
    output + board.join("\n") + "\n.\n"
  end

  private
  def new_board
    board = Array.new(8)
    board.map! { Array.new(8) }

    board[3][3] = 1
    board[3][4] = 0
    board[4][3] = 0
    board[4][4] = 1
    self.board = board
  end
end

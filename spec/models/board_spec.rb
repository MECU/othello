require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { Board.new }
  let(:blank_row) { [nil, nil, nil, nil, nil, nil, nil, nil] }
  let(:new_board) do
    [
      blank_row,
      blank_row,
      blank_row,
      [nil, nil, nil, 1, 0, nil, nil, nil],
      [nil, nil, nil, 0, 1, nil, nil, nil],
      blank_row,
      blank_row,
      blank_row
    ]
    end
  let(:board_display) do
    <<-OUTPUT
 abcdefgh
1        
2        
3        
4   10   
5   01   
6        
7        
8        
.
OUTPUT
  end

  it 'creates a new board' do
    expect(board.board).to eq(new_board)
  end

  it 'display an initial board' do
    expect(board.to_s).to eq(board_display)
  end
end

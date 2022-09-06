require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'initial board' do
    let(:board) { Board.create }
    let(:blank_row) { Array.new(8) }
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
      expect(board.board).to eq(new_board.flatten)
    end

    it 'display an initial board' do
      expect(board.to_s).to eq(board_display)
    end

    it 'has the correct legal moves' do
      expect(board.send(:legal_moves)).to eq([19, 26, 37, 44])
    end

    it 'marks a legal move and updates board' do
      board.move!(19)
      expect(board.board[19]).to eq(0)
      expect(board.board[27]).to eq(0)
      expect(board.board[28]).to eq(0)
      expect(board.board[35]).to eq(0)
    end

    it 'marks a legal move in history' do
      board.move!(19)
      expect(board.history[19]).to eq(JSON.parse({color: 0, order: 1}.to_json))
    end
  end
end

require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { Board.create }
  let(:blank_row) { Array.new(8) }

  describe 'initial board' do
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
      ].flatten
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

  describe 'black move a4' do
    let(:initial_board) do
      [
        blank_row,
        [0, 0, 0, nil, nil, nil, nil, nil],
        [1, 1, 0, nil, nil, nil, nil, nil],
        [nil, 1, 0, nil, nil, nil, nil, nil],
        [1, 1, 0, nil, nil, nil, nil, nil],
        [0, 0, 0, nil, nil, nil, nil, nil],
        blank_row,
        blank_row
      ].flatten
    end

    it 'marks all surrounding squares black' do
      board.board = initial_board
      board.move!(24)
      expect(board.board[16]).to eq(0)
      expect(board.board[17]).to eq(0)
      expect(board.board[25]).to eq(0)
      expect(board.board[32]).to eq(0)
      expect(board.board[33]).to eq(0)
      (0..7).each { |i| expect(board.board[i]).to be_nil }
      (4..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (5..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (6..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (7..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (48..63).each { |i| expect(board.board[i]).to be_nil }
    end
  end

  describe 'black move h4' do
    let(:initial_board) do
      [
        blank_row,
        [nil, nil, nil, nil, nil, 0, 0, 0],
        [nil, nil, nil, nil, nil, 0, 1, 1],
        [nil, nil, nil, nil, nil, 0, 1, nil],
        [nil, nil, nil, nil, nil, 0, 1, 1],
        [nil, nil, nil, nil, nil, 0, 0, 0],
        blank_row,
        blank_row
      ].flatten
    end

    it 'marks all surrounding squares black' do
      board.board = initial_board
      board.move!(31)
      expect(board.board[22]).to eq(0)
      expect(board.board[23]).to eq(0)
      expect(board.board[30]).to eq(0)
      expect(board.board[38]).to eq(0)
      expect(board.board[39]).to eq(0)
      (0..7).each { |i| expect(board.board[i]).to be_nil }
      (0..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (1..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (2..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (3..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (4..64).step(8).each { |i| expect(board.board[i]).to be_nil }
      (48..63).each { |i| expect(board.board[i]).to be_nil }
    end
  end

  describe 'black move h2' do
    let(:initial_board) do
      [
        [1, 0, 0, 0, 0, 0, 1, nil],
        [0, 0, 0, 0, 0, 0, nil, nil],
        [0, 0, 1, 0, 1, 0, 1, nil],
        [1, 1, 1, 1, 1, 1, 1, nil],
        [1, 1, 1, 1, 1, 0, 1, nil],
        [1, 1, 1, 1, 0, 1, 1, nil],
        [1, 1, 1, 1, 1, 1, 1, nil],
        [0, 0, 0, 0, 0, 0, 1, 0],
      ].flatten
    end

    it 'marks all surrounding squares black' do
      board.board = initial_board
      board.move!(15)
      expect(board.board[22]).to eq(0)
      expect(board.board[29]).to eq(0)
      expect(board.board[36]).to eq(0)
      expect(board.board[43]).to eq(0)
      expect(board.board[50]).to eq(0)

      expect(board.board[8]).to eq(0)

      expect(board.board[7]).to be_nil
      expect(board.board[14]).to be_nil
      expect(board.board[23]).to be_nil
    end
  end

  describe 'no moves for black' do
    let(:initial_board) do
      [
        blank_row,
        blank_row,
        blank_row,
        [nil, nil, nil, 0, 0, 0, nil, nil],
        [nil, nil, nil, 0, 1, 0, nil, nil],
        [nil, nil, nil, 0, 0, 0, nil, nil],
        blank_row,
        blank_row,
      ].flatten
    end

    it 'gives no legal moves' do
      board.board = initial_board
      expect(board.legal_moves).to eq([])
    end
  end

  describe '#coordinate_game' do
    # http://transcripts.worldothello.org/woc_history/2019/transcripts/round_14/html/TAKAHASHI%20Aki-TAKANASHI%20Yus_2.htm
    let(:final_board) do
      [
        [1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,1,0,1,0,0,0],
        [1,1,1,1,0,0,0,0],
        [1,1,1,1,1,1,0,0],
        [1,1,0,0,0,0,0,0],
        [1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0],
      ].flatten
      end
    let(:board_52) do
      [
        [1,0,0,0,0,0,1,nil],
        [0,0,0,0,0,0,nil,nil],
        [0,0,1,0,1,0,1,nil],
        [1,1,1,1,1,1,1,nil],
        [1,1,1,1,1,0,1,nil],
        [1,1,1,1,0,1,1,nil],
        [1,1,1,1,1,1,1,nil],
        [0,0,0,0,0,0,1,0],
      ].flatten
    end
    let(:board_53) do
      [
        [1,0,0,0,0,0,1,nil],
        [0,0,0,0,0,0,nil,0],
        [0,0,1,0,1,0,0,nil],
        [1,1,1,1,1,0,1,nil],
        [1,1,1,1,0,0,1,nil],
        [1,1,1,0,0,1,1,nil],
        [1,1,0,1,1,1,1,nil],
        [0,0,0,0,0,0,1,0],
      ].flatten
    end
    let(:board_54) do
      [
        [1,0,0,0,0,0,1,nil],
        [0,0,0,0,0,0,nil,0],
        [0,0,1,0,1,1,1,1],
        [1,1,1,1,1,0,1,nil],
        [1,1,1,1,0,0,1,nil],
        [1,1,1,0,0,1,1,nil],
        [1,1,0,1,1,1,1,nil],
        [0,0,0,0,0,0,1,0],
      ].flatten
    end
    let(:board_55) do
      [
        [1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,nil,0],
        [0,0,1,0,1,1,1,1],
        [1,1,1,1,1,0,1,nil],
        [1,1,1,1,0,0,1,nil],
        [1,1,1,0,0,1,1,nil],
        [1,1,0,1,1,1,1,nil],
        [0,0,0,0,0,0,1,0],
      ].flatten
    end

    it 'gives the correct board after move 52' do
      input = 'f5d6c4d3c3f4f6f3e6e7c6g6g5f7e2c7d8c5b5e8f8b3d7b6e3g3a6g4c8b7a3d2e1c2b1b8b4g7h8a4a8g8f2c1d1g1b2a1f1a7a2a5'
      board = Board.coordinate_game(input)
      expect(board.board).to eq(board_52)
    end

    it 'gives the correct board after move 53' do
      input = 'f5d6c4d3c3f4f6f3e6e7c6g6g5f7e2c7d8c5b5e8f8b3d7b6e3g3a6g4c8b7a3d2e1c2b1b8b4g7h8a4a8g8f2c1d1g1b2a1f1a7a2a5h2'
      board = Board.coordinate_game(input)
      expect(board.board).to eq(board_53)
    end

    it 'gives the correct board after move 54' do
      input = 'f5d6c4d3c3f4f6f3e6e7c6g6g5f7e2c7d8c5b5e8f8b3d7b6e3g3a6g4c8b7a3d2e1c2b1b8b4g7h8a4a8g8f2c1d1g1b2a1f1a7a2a5h2h3'
      board = Board.coordinate_game(input)
      expect(board.board).to eq(board_54)
    end

    it 'gives the correct board after move 55' do
      input = 'f5d6c4d3c3f4f6f3e6e7c6g6g5f7e2c7d8c5b5e8f8b3d7b6e3g3a6g4c8b7a3d2e1c2b1b8b4g7h8a4a8g8f2c1d1g1b2a1f1a7a2a5h2h3h1'
      board = Board.coordinate_game(input)
      expect(board.board).to eq(board_55)
      expect(board.turn).to eq(false)
    end

    it 'gives the correct final board' do
      input = 'f5d6c4d3c3f4f6f3e6e7c6g6g5f7e2c7d8c5b5e8f8b3d7b6e3g3a6g4c8b7a3d2e1c2b1b8b4g7h8a4a8g8f2c1d1g1b2a1f1a7a2a5h2h3h1h7h6g2h5h4'
      board = Board.coordinate_game(input)
      expect(board.board).to eq(final_board)
    end
  end
end

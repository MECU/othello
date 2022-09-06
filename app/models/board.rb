class Board < ApplicationRecord
  DIRECTIONS = [-9, -8, -7, -1, 1, 7, 8, 9]

  after_initialize :setup

  def to_s
    output = " abcdefgh\n"
    board_output = board.map { |p| p.nil? ? ' ' : p }.join.scan(/.{8}/)
    board_output.map!.with_index(1) { |r, i| i.to_s + r }
    output + board_output.join("\n") + "\n.\n"
  end

  def move!(spot)
    return false unless legal_move?(spot)
    self.board[spot] = player_turn
    update_board(spot)
    history[spot] = {color: player_turn, order: moves}
    self.turn = !turn
    self.moves += 1
    save!
  end

  private

    def setup
      self.history = Array.new(64)
      new_board = Array.new(64)
      new_board[27] = 1
      new_board[28] = 0
      new_board[35] = 0
      new_board[36] = 1
      self.board = new_board
    end

    def legal_move?(spot)
      legal_moves.include?(spot)
    end

    def legal_moves
      moves = []
      (0..63).each do |s|
        next unless board[s].nil?
        moves << s if (DIRECTIONS.map { |dir| search?(s, dir) }).any?
      end
      moves
    end

    def search?(s, dir)
      s += dir
      return false unless s > -1 && s < 64
      return false if board[s].nil?
      return false if board[s] == player_turn

      while s > -1 && s < 63
        s += dir
        return false if board[s].nil?
        return true if board[s] == player_turn
      end

      false
    end

    def player_turn
      return 0 if turn == false
      1
    end

    def update_board(s)
      DIRECTIONS.each do |dir|
        ss = s + dir
        while ss > -1 && ss < 63
          break if board[ss].nil?
          break if board[ss] == player_turn
          board[ss] = player_turn
          ss += dir
        end
      end
    end
end

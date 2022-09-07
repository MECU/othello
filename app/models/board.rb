class Board < ApplicationRecord
  DIRECTIONS = [-9, -8, -7, -1, 1, 7, 8, 9]
  ASCII_CHR_OFFSET = 97

  after_initialize :setup

  def to_s
    output = " abcdefgh\n"
    board_output = board.map { |p| p.nil? ? ' ' : p }.join.scan(/.{8}/)
    board_output.map!.with_index(1) { |r, i| i.to_s + r }
    output + board_output.join("\n") + "\n.\n"
  end

  def move!(spot)
    raise ArgumentError, spot unless legal_move?(spot)
    self.board[spot] = player_turn
    update_board(spot)
    history[spot] = {color: player_turn, order: moves}
    self.turn = !turn
    self.moves += 1
    skip_turn
    save!
  end

  def self.coordinate_game(input)
    game = self.new
    moves = input.downcase.scan(/.{2}/)
    moves.each do |m|
      x = m[0].ord - ASCII_CHR_OFFSET
      y = (m[1].to_i - 1) * 8
      game.move!(x + y)
    end
    game
  end

  def legal_moves
    moves = []
    (0..63).each do |s|
      next unless board[s].nil?
      valid_move = DIRECTIONS.map { |dir| search?(s, dir) }
      moves << s if valid_move.any?
    end
    moves
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

    def search?(s, dir)
      return false unless should_traverse?(dir, s)
      s += dir
      return false unless (0..63) === s
      return false if board[s].nil?
      return false if board[s] == player_turn

      while (0..63) === s
        return false unless should_traverse?(dir, s)
        s += dir
        return false if board[s].nil?
        return true if board[s] == player_turn
      end

      false
    end

    def player_turn
      return 1 if turn
      0
    end

    def update_board(s)
      DIRECTIONS.each do |dir|
        next unless should_traverse?(dir, s)
        ss = s + dir
        valid = false
        while (0..63) === ss && !valid
          break if board[ss].nil?
          valid = true if board[ss] == player_turn
          break unless should_traverse?(dir, ss)
          ss += dir
        end

        next unless valid

        ss = s + dir
        while (0..63) === ss
          break if board[ss] == player_turn || board[ss].nil?
          board[ss] = player_turn
          break unless should_traverse?(dir, ss)
          ss += dir
        end
      end
    end

    def should_traverse?(dir, s)
      return false unless (0..63) === s + dir

      case dir
        when -9, -1, 7
          !(s % 8).zero?
        when -8
          s > 8
        when -7, 1, 9
          s % 8 != 7
        when 8
          s < 55
        else
          raise ArgumentError, "dir #{dir} not supported"
      end
    end

    def skip_turn
      self.turn = !self.turn if legal_moves == []
    end
end

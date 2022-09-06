class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.integer :black # player
      t.integer :white # player
      t.jsonb :board, null: false
      t.jsonb :history, null: false
      t.integer :moves, null: false, default: 1
      t.boolean :turn, null: false, default: 0
      t.integer :black_score
      t.integer :white_score
      t.integer :winner

      t.timestamps
    end
  end
end

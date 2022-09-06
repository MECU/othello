class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.integer :black
      t.integer :white
      t.jsonb :board, null: false
      t.integer :black_score
      t.integer :white_score
      t.integer :winner

      t.timestamps
    end
  end
end

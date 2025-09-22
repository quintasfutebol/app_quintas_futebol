class CreatePlayerMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :player_matches do |t|
      t.references :match, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.integer :goals_scored, default: 0
      t.boolean :is_goalkeeper, default: false

      t.timestamps
    end
  end
end

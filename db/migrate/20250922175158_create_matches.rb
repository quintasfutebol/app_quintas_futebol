class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :account, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end

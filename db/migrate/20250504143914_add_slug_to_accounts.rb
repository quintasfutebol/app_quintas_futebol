class AddSlugToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :slug, :string
    add_index :accounts, :slug, unique: true
  end
end

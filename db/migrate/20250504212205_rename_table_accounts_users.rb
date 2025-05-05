class RenameTableAccountsUsers < ActiveRecord::Migration[8.0]
  def change
    rename_table :accounts_users, :account_users
  end
end

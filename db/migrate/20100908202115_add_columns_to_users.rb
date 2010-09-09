class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_id, :integer
    add_column :users, :nickname, :string
    add_column :users, :time_zone, :string
  end

  def self.down
    remove_column :users, :time_zone
    remove_column :users, :nickname
    remove_column :users, :account_id
  end
end

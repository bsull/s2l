class DropTableAccountTargets < ActiveRecord::Migration
  def self.up
    drop_table :account_targets
  
  end

  def self.down
  end
end

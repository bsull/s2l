class DropTableUserTargets < ActiveRecord::Migration
  def self.up
    drop_table :user_targets
  end

  def self.down
  end
end

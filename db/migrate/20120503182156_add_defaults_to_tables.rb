class AddDefaultsToTables < ActiveRecord::Migration
  def self.up
    change_column :opportunity_records, :order_value_cents, :integer, :default => 0
    change_column :targets, :q1_cents, :integer, :default => 0
    change_column :targets, :q2_cents, :integer, :default => 0
    change_column :targets, :q3_cents, :integer, :default => 0
    change_column :targets, :q4_cents, :integer, :default => 0
  end                       

  def self.down    
    change_column :opportunity_records, :order_value_cents, :decimal
    change_column :targets, :q1_cents, :integer
    change_column :targets, :q2_cents, :integer
    change_column :targets, :q3_cents, :integer
    change_column :targets, :q4_cents, :integer
  end
end

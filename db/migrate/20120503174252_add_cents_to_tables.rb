class AddCentsToTables < ActiveRecord::Migration
    def self.up
      rename_column :targets, :q1, :q1_cents
      rename_column :targets, :q2, :q2_cents
      rename_column :targets, :q3, :q3_cents
      rename_column :targets, :q4, :q4_cents
      rename_column :opportunity_records, :order_value, :order_value_cents
      change_column :opportunities, :order_value_cents, :integer, :default => 0
    end

    def self.down
      rename_column :targets, :q1_cents, :q1
      rename_column :targets, :q2_cents, :q2
      rename_column :targets, :q3_cents, :q3
      rename_column :targets, :q4_cents, :q4
      rename_column :opportunity_records, :order_value_cents, :order_value
      change_column :opportunities, :order_value_cents, :integer
    end
  end


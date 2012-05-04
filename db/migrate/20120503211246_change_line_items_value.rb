class ChangeLineItemsValue < ActiveRecord::Migration
  def self.up
    change_column :line_items, :value_cents, :integer, :default => 0
  end

  def self.down
    change_column :line_items, :value_cents, :integer
  end
end

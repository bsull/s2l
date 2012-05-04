class RenameLineItemsValue < ActiveRecord::Migration
  def self.up
    rename_column :line_items, :value, :value_cents
  end

  def self.down
    rename_column :line_items,  :value_cents, :value
  end
end

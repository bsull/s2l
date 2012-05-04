class RemoveOrderValuefromOpportunity < ActiveRecord::Migration
  def self.up
    remove_column :opportunities, :order_value
  end

  def self.down
    add_column :opportunities, :order_value, :integer
  end
end

class AddOrderValueCentsToOpportunity < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :order_value_cents, :integer
  end

  def self.down
    remove_column :opportunities, :order_value_cents
  end
end

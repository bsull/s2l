class AddColumnToOpportunity < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :stale, :boolean
  end

  def self.down
    remove_column :opportunities, :stale
  end
end

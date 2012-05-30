class FixColumnName < ActiveRecord::Migration
  def self.up
    rename_column :opportunities, :update_requirement, :expiration_date
  end

  def self.down
    rename_column :opportunities, :expiration_date, :update_requirement
  end
end

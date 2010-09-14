class AddUpdateRequirementToOpportunity < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :update_requirement, :date
  end

  def self.down
    remove_column :opportunities, :update_requirement
  end
end

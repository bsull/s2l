class ChangeItoBi < ActiveRecord::Migration
  def self.up
    change_column :line_items,          :value_cents,       :bigint, :default => 0
    change_column :opportunities,       :order_value_cents, :bigint, :default => 0
    change_column :opportunity_records, :order_value_cents, :bigint, :default => 0
    change_column :targets,             :q1_cents,          :bigint, :default => 0
    change_column :targets,             :q2_cents,          :bigint, :default => 0
    change_column :targets,             :q3_cents,          :bigint, :default => 0
    change_column :targets,             :q4_cents,          :bigint, :default => 0
  end

  def self.down
    change_column :line_items,          :value_cents,       :integer, :default => 0
    change_column :opportunities,       :order_value_cents, :integer, :default => 0
    change_column :opportunity_records, :order_value_cents, :integer, :default => 0
    change_column :targets,             :q1_cents,          :integer, :default => 0
    change_column :targets,             :q2_cents,          :integer, :default => 0
    change_column :targets,             :q3_cents,          :integer, :default => 0
    change_column :targets,             :q4_cents,          :integer, :default => 0
  end
end

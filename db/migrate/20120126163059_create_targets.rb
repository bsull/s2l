class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
      t.integer :fiscal_year
      t.integer :q1
      t.integer :q2
      t.integer :q3
      t.integer :q4
      t.string :targetable_type
      t.integer :targetable_id

      t.timestamps
    end
  end

  def self.down
    drop_table :targets
  end
end

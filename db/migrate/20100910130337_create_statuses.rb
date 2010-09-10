class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer :account_id
      t.string :name
      t.string :description
      t.boolean :enabled
      t.boolean :forecasted

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end

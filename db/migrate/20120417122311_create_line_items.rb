class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :opportunity_id
      t.integer :product_id
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :line_items
  end
end

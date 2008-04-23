class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.text :description
      t.integer :user_id
      t.boolean :active
      t.timestamp :active_until
      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end

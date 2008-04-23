class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.string :description
      t.string :embellished_description
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :achievements
  end
end

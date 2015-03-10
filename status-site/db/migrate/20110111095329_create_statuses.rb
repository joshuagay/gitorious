class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :title
      t.text :body
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end

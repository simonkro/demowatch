class NewFieldsForMailNotification < ActiveRecord::Migration
  def self.up
    add_column :events, :new_delivered_at, :datetime, :null => true
    add_column :events, :updated_delivered_at, :datetime, :null => true
  end

  def self.down
    remove_column :users, :new_delivered_at
    remove_column :users, :updated_delivered_at
  end
end

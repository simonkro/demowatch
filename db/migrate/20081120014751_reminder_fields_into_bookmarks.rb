class ReminderFieldsIntoBookmarks < ActiveRecord::Migration
  def self.up 
    add_column :bookmarks, :reminder_1_delivered_at, :datetime , :null => true
    add_column :bookmarks, :reminder_2_delivered_at, :datetime , :null => true
    remove_column :events, :reminder_1_delivered_at
    remove_column :events, :reminder_2_delivered_at
  end 
 
  def self.down 
    remove_column :bookmarks, :reminder_1_delivered_at
    remove_column :bookmarks, :reminder_2_delivered_at
    add_column :events, :reminder_1_delivered_at, :datetime , :null => true
    add_column :events, :reminder_2_delivered_at, :datetime , :null => true
  end
end

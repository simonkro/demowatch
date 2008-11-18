class RemindersForEvents < ActiveRecord::Migration
  def self.up 
    add_column :events, :reminder_1_delivered_at, :datetime , :null => true
    add_column :events, :reminder_2_delivered_at, :datetime , :null => true
  end 
 
  def self.down 
    remove_column :events, :reminder_1_delivered_at
    remove_column :events, :reminder_2_delivered_at
  end 
end

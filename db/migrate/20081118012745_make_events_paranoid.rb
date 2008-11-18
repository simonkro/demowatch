class MakeEventsParanoid < ActiveRecord::Migration
  def self.up 
    add_column :events, :deleted_at, :datetime 
  end 
 
  def self.down 
    remove_column :events, :deleted_at 
  end 
end


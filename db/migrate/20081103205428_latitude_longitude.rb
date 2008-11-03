class LatitudeLongitude < ActiveRecord::Migration
  def self.up
    rename_column :events, 'zip', 'address'
    add_column :events, 'latitude', :float
    add_column :events, 'longitude', :float
  end

  def self.down
    rename_column( :events, 'address', 'zip');	
    remove_column :events, 'latitude'    
    remove_column :events, 'longitude'    
  end
end

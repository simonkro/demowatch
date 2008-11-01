class MoreEventFields < ActiveRecord::Migration
  def self.up
    add_column :events, 'zip', :string
    add_column :events, 'city', :string
    add_column :events, 'location', :string
    add_column :events, 'link', :string
  end

  def self.down
    remove_column :events, 'zip'
    remove_column :events, 'city'
    remove_column :events, 'location'
    remove_column :events, 'link'
  end
end

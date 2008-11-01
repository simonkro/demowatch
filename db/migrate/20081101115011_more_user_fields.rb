class MoreUserFields < ActiveRecord::Migration
  def self.up
    add_column :users, 'zip', :string
  end

  def self.down
    remove_column :users, 'zip', :string
  end
end

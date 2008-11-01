class MoreOrganisationFields < ActiveRecord::Migration
  def self.up
    add_column :organisations, 'link', :string
  end

  def self.down
    remove_column :organisations, 'link'
  end
end

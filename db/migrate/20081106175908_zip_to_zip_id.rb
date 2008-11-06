class ZipToZipId < ActiveRecord::Migration
  def self.up
    add_column :users, 'zip_id', :integer
    remove_column :users, 'zip'
  end

  def self.down
    add_column :users, 'zip' , :string
    remove_column :users, 'zip_id'
  end
end

class Zips < ActiveRecord::Migration
  def self.up
    create_table :zips, :force => true do |t|
      t.column :zip,                    :string, :limit=>5
      t.column :name,                :string
      t.column :latitude, 	:float
      t.column :longitude, 	:float
    end
    add_index :zips, [:zip], :unique => true
    
  end

  def self.down
    drop_table "zips"
  end
end

class CreateOrganizers < ActiveRecord::Migration
  def self.up
    create_table :organizers do |t|
      t.column "user_id", :integer, :null => false
      t.column "organisation_id", :integer, :null => false
      t.column "role", :integer, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :organizers
  end
end

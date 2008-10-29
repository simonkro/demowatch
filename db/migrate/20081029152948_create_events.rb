class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events, :force => true do |t|
      t.column "user_id", :integer, :null => false
      t.column "organisation_id", :integer, :null => false
      t.column 'title', :text
      t.column 'description', :text
      t.column 'startdate', :datetime
      t.column 'enddate', :datetime
      
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

class Organizer < ActiveRecord::Base
  belongs_to :user
  belongs_to :organisation
  
  RoleAdmin = 1
end

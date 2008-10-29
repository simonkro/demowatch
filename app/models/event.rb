class Event < ActiveRecord::Base
  acts_as_taggable
  acts_as_bookmarkable

  belongs_to :user
  belongs_to :organisation
end

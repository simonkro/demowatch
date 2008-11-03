class Event < ActiveRecord::Base
  acts_as_taggable
  acts_as_bookmarkable

  validates_presence_of  :title
  validates_length_of    :title, :within => 3..100
  validates_presence_of  :tag_list

  belongs_to :organisation
end

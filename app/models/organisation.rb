class Organisation < ActiveRecord::Base
  acts_as_taggable
  acts_as_bookmarkable

  has_many :organizers, :dependent => :destroy
  has_many :users, :through => :organizers

  validates_presence_of  :title, :message => 'Name fehlt'
  validates_length_of    :title, :within => 3..100, :message => 'Name ist zu kurz'
end

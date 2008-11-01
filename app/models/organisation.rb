class Organisation < ActiveRecord::Base
  has_many :organizers, :dependent => :destroy
  has_many :users, :through => :organizers
  acts_as_taggable

  validates_presence_of  :title, :message => 'Name fehlt'
  validates_length_of    :title, :within => 3..100, :message => 'Name ist zu kurz'
end

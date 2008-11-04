class Organisation < ActiveRecord::Base
  attr_accessor :confirm

  acts_as_taggable
  acts_as_bookmarkable

  has_many :organizers, :dependent => :destroy
  has_many :users, :through => :organizers

  validates_presence_of   :title,   :message => 'Name fehlt'
  validates_length_of     :title,   :within => 3..100, :message => 'Name ist zu kurz'
  validates_acceptance_of :confirm, :message => 'Sie m&uuml;ssen die Bedingungen akzeptieren!'
  
  
# SEO friendly URLs
  def to_param
    id.to_s+'-' + title.downcase.
    gsub('ä', 'ae').
    gsub('ö', 'oe').
    gsub('ü', 'ue').
    gsub('ß', 'ss').
    gsub(/([^a-z0-9]+)/, ' ').strip().gsub(' ', '-')
  end
  
end

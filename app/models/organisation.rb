class Organisation < ActiveRecord::Base
  attr_accessor :confirm

  acts_as_taggable
  acts_as_bookmarkable

  has_many :organizers, :dependent => :destroy
  has_many :users, :through => :organizers
  has_many :events, :dependent => :destroy
  
  validates_presence_of   :title
  validates_length_of     :title,   :within => 3..100
  validates_presence_of   :link
  
  
# SEO friendly URLs
  def to_param
    id.to_s+'-' + title.downcase.
    gsub('ä', 'ae').
    gsub('ö', 'oe').
    gsub('ü', 'ue').
    gsub('ß', 'ss').
    gsub(/([^a-z0-9]+)/, ' ').strip().gsub(' ', '-')
  end

  def link= value
    if value == ''
      self [:link]=value
    else
      if value =~ /@/
        self [:link]='mailto:'+value unless value =~ /^mailto:/
      elsif value =~ /^http:\/\//
        self [:link]=value
      else
        self [:link]='http://'+value
      end
    end
  end
    
end

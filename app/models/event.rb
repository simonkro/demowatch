class Event < ActiveRecord::Base

  acts_as_taggable
  acts_as_bookmarkable
  acts_as_mappable :default_units => :kms, 
                   :default_formula => :sphere, 
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  acts_as_paranoid


#  before_validation_on_create :geocode_address
  
  validates_presence_of  :address
  validates_presence_of  :title
  validates_length_of    :title, :within => 3..100
  validates_presence_of  :link,    :message => 'Link fehlt'
  validates_presence_of  :tag_list


  belongs_to :organisation
  

# SEO friendly URLs
  def to_param
    id.to_s+'-' + title.downcase.
    gsub('ä', 'ae').
    gsub('ö', 'oe').
    gsub('ü', 'ue').
    gsub('ß', 'ss').
    gsub(/([^a-z0-9]+)/, ' ').strip().gsub(' ', '-')
  end

# pagination parameters
  def self.per_page
    50
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
  
private

  def validate
    ev = Event.find_by_id( id)
    if( !(ev.nil? || ev.address != address))
      return
    end
    geo=GeoKit::Geocoders::MultiGeocoder.geocode(address)
    errors.add(:address, "Adresse wurde nicht gefunden") if !geo.success
    self.address,self.city,self.latitude,self.longitude = geo.full_address,geo.city,geo.lat,geo.lng if geo.success
#    puts( geo.state + '##################');
  end

#  def validate
#    errors.add_to_base "Bitte geben Sie eine Adresse ein." if address.blank?
#  end
  
  
end

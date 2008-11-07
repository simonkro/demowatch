class FrontController < ApplicationController
 
  def index
    @tags = Tag.counts
  end
  
  def events
    @tags = Event.tag_counts
    render :action => 'index'
  end

  def other
    @tags = Tag.counts :conditions => "taggable_type IN ('Organisation', 'User')"
    render :action => 'index'
  end
  
  def add
    current_user.tags << @tag
    render :action => 'index'
  end
  
  def impressum
  end

  def about
  end
  
  def show
    @tag = Tag.find(params[:id])
    @with_distance = !current_user.nil? && !current_user.zip.nil?
    if( @with_distance)	  
      # mit entfernung
  	  origin = GeoKit::LatLng.new(current_user.zip.latitude, current_user.zip.longitude);
      @events = Event.find_tagged_with(@tag, :origin => origin, :order => 'startdate DESC')
    else 
      @events = Event.find_tagged_with(@tag, :order => 'startdate DESC')
    end  
    @organisations = Organisation.find_tagged_with(@tag)
    
  end
end

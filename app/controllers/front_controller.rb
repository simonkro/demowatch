class FrontController < ApplicationController
 
  def index
  end
  
  def all
    @tags = Tag.counts
    render :action => 'index'
  end
  
  def events
    @tags = Event.tag_counts
    render :action => 'index'
  end

  def other
    @tags = Tag.counts :conditions => "taggable_type IN ('Organisation', 'User')"
    render :action => 'index'
  end
 
  def impressum
  end

  def about
  end
  
  def show
  ## hack, um alte links ala /tag/:id nach /tag/:name umzuleiten
    if params[:name].is_numeric?
      tag = Tag.find_by_id(params[:name])
      redirect_to '/tag/' + tag.name, :status=>:moved_permanently
    end
      
      
    @tag = Tag.find_by_name(params[:name])
    @with_distance = !current_user.nil? && !current_user.zip.nil?
    if( @with_distance)	  
      # mit entfernung
  	  origin = GeoKit::LatLng.new(current_user.zip.latitude, current_user.zip.longitude);
      @events = Event.find_tagged_with(@tag, :origin => origin, :order => 'startdate DESC')
    else 
      @events = Event.find_tagged_with(@tag, :order => 'startdate DESC')
    end  
    @organisations = Organisation.find_tagged_with(@tag)
    @related_tags = (@events.map{|e| e.tags} + @organisations.map{|o| o.tags}).flatten.uniq   
  end
end

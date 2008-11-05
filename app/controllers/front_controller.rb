class FrontController < ApplicationController
 
  def index
    @tags = Tag.counts
  end
  
  def events
    @tags = Event.tag_counts
    render :action => 'index'
  end

  def other
    @tags = Tag.counts :conditions => "taggable_type IN ('Organisation', 'Event')"
    render :action => 'index'
  end
    
  def impressum
  end

  def about
  end
  
  def show
    @tag = Tag.find(params[:id])
    @events = Event.find_tagged_with(@tag)
    @organisations = Organisation.find_tagged_with(@tag)
  end
end

class FrontController < ApplicationController
 
  def index
    @tags = Tag.counts
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

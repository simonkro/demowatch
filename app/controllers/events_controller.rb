class EventsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :archive]
  before_filter :find_event, :only => [:show, :edit, :update, :destroy]
  allow :create, :user => [:has_organisation?, :is_admin?]
  allow :edit, :update, :destroy, :user => [:owns?, :is_admin?]
  
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_tag_name'

  def auto_complete_for_tag_name
    @tags = Tag.find(:all, :conditions => [ 'LOWER(name) LIKE ?', params[:event][:tag_list] + '%' ])
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
  end
  
  # GET /events
  # GET /events.xml
  def index
    @tags = params[:tags] 
    @with_distance = !current_user.nil? && !current_user.zip.nil?
    options = {:order => 'startdate ASC', :conditions => "startdate > '#{1.day.ago}'"}
    if @with_distance	  
      options[:origin] = GeoKit::LatLng.new(current_user.zip.latitude, current_user.zip.longitude)
      # options[:within] = distance_in_km # Fuer umkreissuche
      @zip = current_user.zip.zip
    end
    options = Event.find_options_for_find_tagged_with(@tags, options) if @tags
    
    respond_to do |format|
      format.html { @events = Event.paginate(options.merge :page => params[:page], :per_page => 80) }
      format.xml  { render :xml => Event.all(options) }
      format.rss  { @events = Event.all(options); render :layout => false }
      format.ics  { render :inline => ical(Event.all(options)) }
    end
  end
  
  def archive
    @tags = params[:tags] 
    @with_distance = !current_user.nil? && !current_user.zip.nil?
    options = {:order => 'startdate DESC', :conditions => "startdate < '#{1.day.ago}'"}
    if @with_distance   
      options[:origin] = GeoKit::LatLng.new(current_user.zip.latitude, current_user.zip.longitude)
      # options[:within] = distance_in_km # Fuer umkreissuche
      @zip = current_user.zip.zip
    end
    options = Event.find_options_for_find_tagged_with(@tags, options) if @tags
    
    respond_to do |format|
      format.html { @events = Event.paginate(options.merge :page => params[:page], :per_page => 80) }
      format.xml  { render :xml => Event.all(options) }
      format.rss  { @events = Event.all(options); render :layout => false }
      format.ics  { render :inline => ical(Event.all(options)) }
    end
  end  
  
  # GET /events/1
  # GET /events/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
      format.ics  { render :inline => ical([@event]) }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new(:startdate => Time.now)
    @organisations = current_user.organizers.map{|o| o.organisation}
    
    if @organisations.empty?
      flash[:notice] = 'Zuerst muß ein Initiator erstellt werden.'
      redirect_to new_organisation_path 
      return
    end  

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @organisations = Organisation.find(:all)
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Demonstration wurde erfolgreich eingetragen.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        @organisations = Organisation.find(:all)
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Demonstration wurde erfolgreich ge&auml;ndert.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        @organisations = Organisation.find(:all)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
protected
  def find_event
    @event = Event.find(params[:id])
  end
  
  def ical events
    cal = Vpim::Icalendar.create2
    
    events.each do |event|
      cal.add_event do |e|
        e.dtstart       event.startdate
        e.dtend         event.enddate || event.startdate + 4.hours
        e.summary       event.title
        e.description   event.description.gsub(/<[^>]+>|/m, '').to_a.join(' ').gsub(/\s+/, ' ')
        e.categories    event.tags.map{|t| t.name}
        e.url           event.link || ''
        e.transparency  'OPAQUE'
        e.sequence      0
        e.created       event.created_at
        e.lastmod       event.updated_at
        
    #    e.organizer do |o|
    #      o.cn = event.organisation.title
    #      o.uri = event.organisation.link
    #    end
      end
    end
    
    cal.encode
  end  
end

class OrganisationsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_organisation, :only => [:show, :edit, :update, :destroy]
  allow :edit, :update, :destroy, :user => [:owns?, :is_admin?]
  
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_tag_name'

  def auto_complete_for_tag_name
    @tags = Tag.find(:all, :conditions => [ 'LOWER(name) LIKE ?', params[:organisation][:tag_list] + '%' ])
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
  end
    
  # GET /organisations
  # GET /organisations.xml
  def index
    @organisations = Organisation.paginate :order => 'title', :page => params[:page], :per_page => 15

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organisations }
    end
  end

  # GET /organisations/1
  # GET /organisations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organisation }
    end
  end

  # GET /organisations/new
  # GET /organisations/new.xml
  def new
    @organisation = Organisation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organisation }
    end
  end

  # GET /organisations/1/edit
  def edit
  end

  # POST /organisations
  # POST /organisations.xml
  def create
    @organisation = Organisation.new(params[:organisation])
    @organisation.organizers.build(:user => current_user, :role => 1)
    respond_to do |format|
      if @organisation.save
        flash[:notice] = 'Initiator wurde erfolgreich eingetragen.'
        format.html { redirect_to(@organisation) }
        format.xml  { render :xml => @organisation, :status => :created, :location => @organisation }
        InitiatorMailer::deliver_mail(current_user, @organisation)
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organisation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organisations/1
  # PUT /organisations/1.xml
  def update
    respond_to do |format|
      if @organisation.update_attributes(params[:organisation])
        flash[:notice] = 'Initiator wurde erfolgreich ge&auml;ndert.'
        format.html { redirect_to(@organisation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organisation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.xml
  def destroy
    @organisation.destroy

    respond_to do |format|
      format.html { redirect_to(organisations_url) }
      format.xml  { head :ok }
    end
  end
  
protected  
  def find_organisation
    @organisation = Organisation.find(params[:id])
  end
end

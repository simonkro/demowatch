class OrganisationsController < ApplicationController

  before_filter :login_required, :only => [ :new, :create, :edit, :update, :destroy ]
  
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_tag_name'

  def auto_complete_for_tag_name
    @tags = Tag.find(:all, :conditions => [ 'LOWER(name) LIKE ?', params[:organisation][:tag_list] + '%' ])
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
  end
    
  # GET /organisations
  # GET /organisations.xml
  def index
    @organisations = Organisation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organisations }
    end
  end

  # GET /organisations/1
  # GET /organisations/1.xml
  def show
    @organisation = Organisation.find(params[:id])

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
    @organisation = Organisation.find(params[:id])
  end

  # POST /organisations
  # POST /organisations.xml
  def create
    @organisation = Organisation.new(params[:organisation])

    respond_to do |format|
      if @organisation.save
        flash[:notice] = 'Initiative wurde erfolgreich eingetragen.'
        format.html { redirect_to(@organisation) }
        format.xml  { render :xml => @organisation, :status => :created, :location => @organisation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organisation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organisations/1
  # PUT /organisations/1.xml
  def update
    @organisation = Organisation.find(params[:id])

    respond_to do |format|
      if @organisation.update_attributes(params[:organisation])
        flash[:notice] = 'Initiative wurde erfolgreich ge&auml;ndert.'
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
    @organisation = Organisation.find(params[:id])
    @organisation.destroy

    respond_to do |format|
      format.html { redirect_to(organisations_url) }
      format.xml  { head :ok }
    end
  end
end

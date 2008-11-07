class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]

  before_filter :login_required, :except => [:new, :create, :activate, :bookmark, :unbookmark, :add_tag, :del_tag]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :update, :show, :bookmark, :unbookmark, :add_tag, :del_tag]
  allow :suspend, :unsuspend, :destroy, :purge, :user => :is_admin?
  allow :show, :edit, :update, :bookmark, :unbookmark, :add_tag, :del_tag, :user => [:owns?, :is_admin?]
  
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_tag_name'

  def auto_complete_for_tag_name
    @tags = Tag.all :conditions => [ 'LOWER(name) LIKE ?', params[:user][:tag_list] + '%' ]
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
  end

  def show
    @organisations = @user.organisations
    @events = @user.events    
  end
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Vielen Dank f&uuml;r die Anmeldung!"
    else
      render :action => 'new'
    end
  end

  def edit
    @str_zip = @user.zip.nil? ? '' : @user.zip.zip
  end
  
  def update
    @user.zip = Zip.find_by_zip( params[:user][:zip])    
    params[:user].delete('zip')
    if @user.update_attributes( params[:user])
      flash[:notice] = 'Einstellungen wurden erfolgreich ge&auml;ndert.'
      redirect_to(@user) 
    else
      render :action => "edit"
    end
  end
  
  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Dein Konto wurde aktiviert!"
    end
    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  def bookmark
    if params[:event]
      event = Event.find(params[:event].to_i)
      @user.bookmarks.build(:title => event.title, :bookmarkable => event)
      flash[:notice] = "Du hast erfolgreich Infos zu dieser Demonstration abonniert." if @user.save
      redirect_to event
    elsif params[:organisation]
      organisation = Organisation.find(params[:organisation].to_i)
      @user.bookmarks.build(:title => organisation.title, :bookmarkable => organisation)
      flash[:notice] = "Du hast erfolgreich Infos zu diesem Initiator abonniert." if @user.save
      redirect_to organisation
    else
      redirect_to :front
    end
  end

  def unbookmark
    if params[:event]
      Bookmark.destroy_all :user_id => params[:id], :bookmarkable_id => params[:event], :bookmarkable_type => 'Event'  
      flash[:notice] = "Du hast erfolgreich Infos zu dieser Demonstration abbestellt." 
      redirect_to event_path(params[:event])
    elsif params[:organisation]
      Bookmark.destroy_all :user_id => params[:id], :bookmarkable_id => params[:organisation], :bookmarkable_type => 'Organisation'  
      flash[:notice] = "Du hast erfolgreich Infos zu diesem Initiator abbestellt."
      redirect_to organisation_path(params[:organisation])  
    else
      redirect_to :front
    end
  end
  
  def add_tag
    tag = Tag.find(params[:tag])
    @user.tags << tag
    @user.save
    redirect_to :action => :show, :id => tag
  end
    
 
  def del_tag
    tag = Tag.find(params[:tag])
    @user.tags.delete tag
    @user.save
    redirect_to :action => :show, :id => tag
  end    
    
protected
  def find_user
    @user = User.find(params[:id])
  end

end

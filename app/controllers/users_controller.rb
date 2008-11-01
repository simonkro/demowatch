class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :update, :show, :bookmark]
  
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_tag_name'

  def auto_complete_for_tag_name
    @tags = Tag.find(:all, :conditions => [ 'LOWER(name) LIKE ?', params[:user][:tag_list] + '%' ])
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
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
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
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
      flash[:notice] = "Signup complete!"
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
      flash[:notice] = "Bookmark wurde angelegt." if @user.save
    end
    if params[:organisation]
      organisation = Organisation.find(params[:organisation].to_i)
      @user.bookmarks.build(:title => organisation.title, :bookmarkable => organisation)
      flash[:notice] = "Bookmark wurde angelegt." if @user.save
    end
    
    redirect_to :back
  end

  def unbookmark
    if params[:event]
      Bookmark.destroy_all ["user_id = ? and bookmarkable_id = ? and bookmarkable_type = 'Event'", params[:id], params[:event]]  
      flash[:notice] = "Bookmark wurde entfernt." 
    end
    if params[:organisation]
      Bookmark.destroy_all ["user_id = ? and bookmarkable_id = ? and bookmarkable_type = 'Organisation'", params[:id], params[:organisation]]  
      flash[:notice] = "Bookmark wurde entfernt." 
    end
    
    redirect_to :back
  end
  
    
protected
  def find_user
    @user = User.find(params[:id])
  end

end

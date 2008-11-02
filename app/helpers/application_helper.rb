# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def is_admin?
    current_user && current_user.role == User::RoleAdmin     
  end
  
  def may_edit? item
    return true if is_admin?
    case item 
      when Organisation
        organizer = current_user.organizers & item.organizers
        !organizer.empty? && organizer.first.role == Organizer::RoleAdmin  
      when Event
        organizer = current_user.organizers & item.organisation.organizers
        !organizer.empty? && organizer.first.role == Organizer::RoleAdmin  
      when User
        item == current_user 
    end
  end
end

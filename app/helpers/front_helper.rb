module FrontHelper
  def tag_cloud(tags, classes, user)
    return if tags.empty?
    
    max_count = tags.map(&:count).max.to_f
    user_tags = Set.new(user && user.tags || [])
    
    tags.sort_by{|tag| tag.name}.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index] + " #{'usertag' if user_tags.include? tag}"
    end
  end
end

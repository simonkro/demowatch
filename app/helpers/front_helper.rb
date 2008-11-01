module FrontHelper
  def tag_cloud(tags, classes)
    return if tags.empty?
    
    max_count = tags.map(&:count).max.to_f
    
    tags.sort_by{|tag| tag.name}.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end
end

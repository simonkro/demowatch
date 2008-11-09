xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "Demowatch"
    if @tags
      xml.description "Themen: #{@tags}"
    else
      xml.description "alle Demos"
    end 
    xml.tag! 'atom:link', :href => events_url + '.rss', :rel => 'self'
    xml.link events_url

    for event in @events
      xml.item do
        xml.title event.title
        xml.description event.description
        xml.pubDate event.created_at.to_s(:rfc822)
        xml.link event_url(event)
        xml.guid event_url(event)
      end
    end
  end
end

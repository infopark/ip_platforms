xml.instruct! :xml, :version => '1.0'

xml.rss :version => '2.0' do
  xml.channel do
    xml.title @conference.name
    xml.link @my_url
    xml.description @conference.description

    if @conference.participants.any?
      @conference.participants.each do |participant|
        p = participant.username
        if show_details?(@conference, participant)
          if @current_user == participant
            p += " (You)"
          else
            p += " (#{participant.fullname}, <#{participant.email}>)"
          end
        end
        xml.item do
          xml.title p
          xml.description "#{p} is a participant of #{@conference.name}"
          xml.pubDate @conference.updated_at.rfc2822
          xml.guid url_for(:controller => :members, :action => :show,
                           :id => participant, :only_path => false)
        end
      end
    end
  end
end

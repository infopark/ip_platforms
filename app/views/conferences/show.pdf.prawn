pdf.draw_text 'Generated by Infopark AG', :at => pdf.bounds.absolute_bottom_left

pdf.font 'Helvetica'

pdf.text @conference.name, :size => 16, :style => :bold
pdf.text "#{@conference.startdate} - #{@conference.enddate}"
pdf.move_down pdf.font.height * 1

if @conference.serie
  pdf.text "Series: #{@conference.serie.name}"
end

if @conference.categories.any?
  categories = []
  @conference.categories.each do |category|
    categories << category.name
  end
  pdf.text "Categories: #{categories.join(', ')}"
end

pdf.move_down pdf.font.height * 1

pdf.text "Location: #{@conference.location}" if @conference.location
pdf.text "Venue: #{@conference.venue}" if @conference.venue
pdf.text "How to find: #{@conference.howtofind}" if @conference.howtofind

pdf.move_down pdf.font.height * 1
pdf.text "Accomodation: #{@conference.accomodation}" if @conference.accomodation

if @conference.participants.any?
  pdf.move_down pdf.font.height * 2
  pdf.text "Participants:"
  @conference.participants.each do |participant|
    p = participant.username
    if @conference.creator == @current_user or
        @current_user.friends.include?(participant) or
        @current_user == participant
      if @current_user == participant
        p += " (You)"
      else
        p += " (#{participant.fullname}, <#{participant.email}>)"
      end
    end
    pdf.text p, :indent_paragraphs => 40
  end
end

pdf.move_down pdf.font.height * 3
pdf.text "More Information: #{@my_url}"

$stderr.puts "#{url_for(@conference)}"

module ConferencesHelper

  def conference_location_select_tag(selected_location)
    options = [
      ['conferences at all locations', ''],
    ]
    if @current_user && @current_user.has_gps_data?
      [50, 500, 2000, 5000].each do |distance|
        options << ["only conferences <#{distance}km away", distance]
      end
    end
    select_tag(:location, options_for_select(options, selected_location))
  end

end

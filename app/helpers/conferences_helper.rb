module ConferencesHelper

  def conference_location_select_tag(selected_location)
    if @current_user
      options = []
      unless @current_user.country.blank?
        options << ["only conferences in #{@current_user.country}", 'myCountry']
      end
      if @current_user.has_gps_data?
        [50, 500, 2000, 5000].each do |distance|
          ["only conferences <#{distance}km away", distance]
        end
      end
      select_tag(:location, options_for_select(options, selected_location))
    end
  end

end

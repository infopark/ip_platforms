module GpsLocation

  def self.included(base)
    base.attr_accessible(:gps)
    base.validates(:gps, :format => {
      :with => %r{\d+(\.\d+)? ?[NnSs] ?,? ?\d+(\.\d+)? ?[EeWw]},
    }, :allow_nil => true)
    base.after_validation(:set_lat_lng_from_gps_after_validation)
  end

  def gps
    if @gps.blank?
      @gps = [
        unless lat.blank?
          if lat > 0
            "#{lat}N"
          else
            "#{-lat}S"
          end
        end,
        unless lng.blank?
          if lng > 0
            "#{lng}E"
          else
            "#{-lng}W"
          end
        end,
      ].flatten.join(',')
    end
    @gps
  end

  def gps=(value)
    @gps = value
  end

  def set_lat_lng_from_gps_after_validation
    if !gps.blank? && errors[:gps].empty?
      if m = "#{gps}".match(%r{([\d\.]+) ?([NnSs]) ?,? ?([\d+\.]+) ?([EeWw])})
        self.lat = m[1]
        self.lng = m[3]
        self.lat = -lat if ['s', 'S'].include?(m[2])
        self.lng = -lng if ['w', 'W'].include?(m[4])
      end
    end
    true
  end

  def has_gps_data?
    !lat.blank? && !lng.blank?
  end

end

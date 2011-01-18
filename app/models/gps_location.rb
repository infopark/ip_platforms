module GpsLocation

  def self.included(base)
    base.attr_accessible(:gps)
    base.validates(:gps, :format => {
      :with => %r{\d+(\.\d+)? ?[NnSs] ?,? ?\d+(\.\d+)? ?[EeWw]},
    }, :allow_nil => true)
    base.after_validation(:set_lat_lng_from_gps_after_validation)
  end

  def gps
    @gps
  end

  def gps=(value)
    @gps = value
  end

  def set_lat_lng_from_gps_after_validation
    if !gps.blank? && errors[:gps].empty?
      m = "#{gps}".match(%r{([\d\.]+) ?([NnSs]) ?,? ?([\d+\.]+) ?([EeWw])})
      self.lat = p[1]
      self.lng = p[3]
      self.lat = -lat if ['s', 'S'].include?(p[2])
      self.lng = -lng if ['w', 'W'].include?(p[2])
    end
  end

end

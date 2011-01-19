if defined? Geokit

  Geokit::default_units = :kms
  Geokit::default_formula = :sphere
  Geokit::Geocoders::request_timeout = 3
  Geokit::Geocoders::proxy_addr = nil
  Geokit::Geocoders::proxy_port = nil
  Geokit::Geocoders::proxy_user = nil
  Geokit::Geocoders::proxy_pass = nil
  Geokit::Geocoders::yahoo = false
  Geokit::Geocoders::google = 'ABQIAAAAgPYResB-xeyHxmDCgjO0lxQV8G4RNoBTn2MdTAz94FeqHhhEmBSzf6AOjS-GP-_hvbRuxrLLTYBDuQ'
  Geokit::Geocoders::geocoder_us = false
  Geokit::Geocoders::geocoder_ca = false
  Geokit::Geocoders::provider_order = [:google]
  Geokit::Geocoders::ip_provider_order = []

end

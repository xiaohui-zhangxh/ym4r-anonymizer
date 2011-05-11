require 'rubygems'
begin
  require 'ym4r/anonymizer'
rescue
  # debug local script mode
  $:.unshift File.join(File.dirname(__FILE__), '../lib')
  require 'ym4r/anonymizer'
end

Ym4r::Anonymizer.config = YAML.load_file(File.expand_path('../ym4r_anonymizer.yml', __FILE__))
Ym4r::Anonymizer.verbos = true
Ym4r::GoogleMaps::Geocoding.get('Chengdu, Sichuan, China')
Ym4r::GoogleMaps::Geocoding.get('Beijing, China')
Ym4r::GoogleMaps::Geocoding.get('Chongqing, China')
Ym4r::Anonymizer.config[:proxy] = nil
Ym4r::GoogleMaps::Geocoding.get('Chengdu, Sichuan, China')
Ym4r::GoogleMaps::Geocoding.get('Beijing, China')
Ym4r::GoogleMaps::Geocoding.get('Chongqing, China')

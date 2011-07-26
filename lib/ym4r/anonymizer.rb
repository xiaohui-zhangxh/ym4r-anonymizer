
require 'ym4r'

module Ym4r
  module Anonymizer

    Version = "0.0.2"
  
    @config = {}
    
    #Ym4r::Anonymizer.config = {
    #  :proxy => { 
    #    :host => '127.0.0.1', 
    #    :port => 8123, 
    #    :username => 'user', 
    #    :password => 'pwd',
    #   },
    #  :google_api_keys => [
    #    'ABQIAAAAzMUFFnT9uH0xq39J0Y4kbhTJQa0g3IQ9GZqIMmInSLzwtGDKaBR6j135zrztfTGVOm2QlWnkaidDIQ',
    #    'ABQIAAAADJ6dxjPhPP3j4JMcarDN1RS3zpQkq3Dy2kJjwfk7zLSQDM4mqxRSmAnhPMLC-mwJSRi2Kd5iUlHW6w',
    #  ],
    #  :yahoo_app_ids => [
    #    'YellowMaps4R',
    #  ]
    #}
    def self.config=(v)
      @config = v
    end
    
    def self.config
      @config
    end
    
    def self.verbos=(v)
      @verbos = v
    end
    
    def self.verbos?
      !!@verbos
    end
    
    def self.included(klass)
      klass.extend ClassMethods
    end
    
    module ClassMethods
    
      def proxy
        proxy = Ym4r::Anonymizer.config[:proxy]
      end
      
      def use_proxy?
        !!proxy
      end
      
      def proxy_use_auth?
        !!(proxy_username && proxy_password)
      end
      
      def proxy_connection_string
        proxy ? "http://#{proxy[:host]}:#{proxy[:port]}" : nil
      end
      
      def proxy_username
        proxy ? proxy[:username] : nil
      end
      
      def proxy_password
        proxy ? proxy[:password] : nil
      end
      
      def google_api_keys
        Ym4r::Anonymizer.config[:google_api_keys] || Array(Ym4r::GoogleMaps::API_KEY)
      end
      
      def yahoo_app_ids
        Ym4r::Anonymizer.config[:yahoo_app_ids] || Array(Ym4r::YahooMaps::APP_ID)
      end
      
      # iterate next API key
      def url_with_next_key(url)
        case self.name
          when "Ym4r::GoogleMaps::Geocoding"
            @@google_api_key_index ||= 0
            @@google_api_key_index = 0 if @@google_api_key_index >= google_api_keys.size
            key = google_api_keys[@@google_api_key_index]
            @@google_api_key_index += 1
            url.sub(/&key=(.*)&output=/, "&key=#{key}&output=")
          when "Ym4r::YahooMaps::BuildingBlock::Geocoding"
            @@yahoo_app_id_index ||= 0
            @@yahoo_app_id_index = 0 if @@yahoo_app_id_index >= yahoo_app_ids.size
            key = yahoo_app_ids[@@yahoo_app_id_index]
            @@yahoo_app_id_index += 1
            url.sub(/appid=(.+)&/, "appid=#{key}&")
          else
            raise "unknown Geocoder #{self.name} for anonymizing ym4r"
        end
      end
      
      def open(url)
        url = url_with_next_key(url)
        puts "[#{Time.now}] fetching #{url}#{' with proxy ' + proxy_connection_string if use_proxy?}" if Ym4r::Anonymizer.verbos?
        if use_proxy?
          opts = if proxy_use_auth?
            {:proxy_http_basic_authentication => [proxy_connection_string, proxy_username, proxy_password]}
          else
            {:proxy => proxy_connection_string}
          end
          Kernel.open(url, opts)
        else
          Kernel.open(url)
        end
      end
    end
  end
end

# include Anonymizer methods with Geocoders
Ym4r::GoogleMaps::Geocoding.send :include, Ym4r::Anonymizer
Ym4r::YahooMaps::BuildingBlock::Geocoding.send :include, Ym4r::Anonymizer


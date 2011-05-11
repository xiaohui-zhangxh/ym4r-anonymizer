
require 'ym4r'

module Ym4r
  module Anonymizer
  
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
        !!(proxy_username && proxy_passwprd)
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
      
      def open(url)
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


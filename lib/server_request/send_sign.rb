require 'digest/md5'
require 'net/http'
require 'uri'
require 'eventmachine'
require 'em-http'

module ServerRequest
  class SendSign
    SECRET = 'i-promise-you-do-not-konw'

    # uri          => 'http://admin.enai.com
    # request_path =>/communities/forums_filter/filter_topic'
    #	hash         => {id => 123}
    def initialize(host, request_path, params_hash)
      @host = host
      @params_hash = params_hash
      @uri = request_path + '?'

      params_hash[:ts] = Time.now.to_i
      @hash = params_hash

      sorted_hash(params_hash).each do |params|
        @uri += ("#{params[0]}=#{params[1]}&")
      end

      encoding_string = @uri.force_encoding(Encoding::UTF_8)
      uri_encoding = URI::escape(encoding_string.to_s, /[^a-zA-Z0-9\-\.\_\~]/)

      sig = create_sign(uri_encoding)
      @uri += ('sig=' + sig)
    end

    def post
      EventMachine.run do
        conn = EventMachine::HttpRequest.new(@host + @uri)
        conn.post(@params_hash)
      end
    end

    def post_sync
      http = Net::HTTP.new(@host + @uri)
      http.post(@params_hash)
    end

    def get
      EventMachine.run do
        conn = EventMachine::HttpRequest.new(@host + @uri)
        conn.get
      end
    end

    def get_sync
      Net::HTTP.get(URI.parse(@host + @uri))
    end

    # string      => id=123&ts=1373006032
    # sign_secret => what-the-fuck?
    # return      => b13d7627cf6e3f0fc25b2f3ead57175c
    def create_sign string
      return Digest::MD5.hexdigest(string + SECRET)
    end

    def sorted_hash hash
      return hash.sort do |a,b|
        a.to_s <=> b.to_s                      
      end
    end
  end
end
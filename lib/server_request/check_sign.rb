require 'digest/md5'
require 'uri'

module ServerRequest
	class CheckSign
		SECRET  = 'i-promise-you-do-not-konw'
		TIMEOUT = 600

		##### format #####
		# uri  => '/communities/forums_filter/filter_topic'
		#	hash => {id  => 123}
		def initialize(uri, params_hash)
			@uri = uri
			@params_hash = params_hash
	  end

		def check_sign
			if check_time "#{@params_hash['ts']}"
				uri = @uri + '?'

				sorted_hash(@params_hash).each do |param|
					next if param[0] == 'sig'
					uri += ("#{param[0]}=#{param[1]}&")
				end

				encoding_string = uri.force_encoding(Encoding::UTF_8)
				uri_encoding = URI::escape(encoding_string.to_s, /[^a-zA-Z0-9\-\.\_\~]/)

				result = pass_sign(uri_encoding, @params_hash['sig'])
			else
				false
			end
		end

		def check_time ts
			(Time.now.to_i - ts.to_i) > TIMEOUT ? false : true
		end

		# string   => id=123&ts=1373006032
		# sig      => b13d7627cf6e3f0fc25b2f3ead57175c
		# return   => true
		def pass_sign string, sig
			Digest::MD5.hexdigest(string + SECRET) == sig ? true : false
		end

		def sorted_hash hash
	    return hash.sort do |a,b|
	    	a.to_s <=> b.to_s                      
	    end
		end
	end

end
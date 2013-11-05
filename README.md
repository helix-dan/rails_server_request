# SingleSignOn

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'server_request', :path => '/xx/.xx/server_request'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install server_request

## Usage

when you need send request(on your controller file):

		host_add     = 'http://localhost'
		request_path = '/communities/space_filter/filter_comment'
		hash = {
			'id' => 123
		}
		send_request = ServerRequest::SendSign.new(host_add, request_path, hash)
		send_request.get

when you need get request(on your controller file):

		local_add = request.env['REQUEST_PATH']

		cs = ServerRequest::CheckSign.new(local_add, request.env['rack.request.query_hash'])
		result = cs.check_sign
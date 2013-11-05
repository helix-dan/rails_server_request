lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|  
  s.name        = 'server_request'
  s.version     = '0.0.4'  
  s.date        = '2013-11-05'  
  s.summary     = "server_request"  
  s.description = "A simple ruby server sign expo gem"  
  s.authors     = ["Helix Dan"]  
  s.email       = 'lotus.bat@gmail.com'  
  s.files       = ["lib/server_request.rb"]  
  s.homepage    =  
    'http://github.com/helix'  
end
$:.unshift File.expand_path('lib')
require 'movie'

timeout = 0
while (timeout < 5)
  break if `ps aux` =~ /beanstalkd$/
  sleep 3
  timeout += 1
end
exit(1) if timeout == 5

include Stalker

job 'movie.create' do |params|
	Movie.create(
		params['tempfile'], 
		:title => params['title'], 
		:description => params['description'], 
		:extension => params['extension']
	)
end
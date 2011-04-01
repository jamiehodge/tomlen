$:.unshift File.expand_path('lib')
require 'movie'
require 'open-uri'

timeout = 0
while (timeout < 5)
  break if `ps aux` =~ /beanstalkd$/
  sleep 3
  timeout += 1
end
exit(1) if timeout == 5

include Stalker

job 'movie.generate_previews' do |params|
	success = Movie.new(params['id']).create_thumbnails && Movie.new(params['id']).create_posterframes
	if success
		puts open(params['success'] + params['id']).read
	else
		puts open(params['failure'] + params['id']).read
	end
end
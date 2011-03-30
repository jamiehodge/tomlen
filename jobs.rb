$:.unshift File.expand_path('lib')
require 'movie'

include Stalker

job 'movie.create' do |params|
	Movie.create(
		params['tempfile'], 
		:title => params['title'], 
		:description => params['description'], 
		:extension => params['extension']
	)
end
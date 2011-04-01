#!/usr/bin/arch -arch i386 /usr/bin/ruby

$:.unshift File.expand_path('lib')
require 'movie'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

configure do
	YAML.load_file('settings.yml').each_pair { |k,v| set k.to_sym, v }
	
	set :haml, { :format => :html5 }
end

get '/movies/new' do
	haml :new
end

get '/movie/:id/original' do
	send_file Movie.new(params[:id]).original
end

%w{thumbnail posterframe}.each do |asset|
	get "/movie/:id/#{asset}/:asset_id" do
		send_file File.join(Movie.new(params[:id]).send("#{asset}s_dir".to_sym), "#{params[:asset_id]}.png")
	end
end

get '/movie/:id' do
	@movie = Movie.new(params[:id])
	haml :show
end

delete '/movie/:id' do
	%w{thumbnail_dir posterframe_dir}.each do |dir|
		FileUtils.rm_r Dir.glob(File.join('public', 'movies', settings.library['dir_prefix'] + params[:id], settings.library[dir], '*'))
	end
	redirect to '/movies'
end

get '/movies' do
	@movies = Dir.glob('public/movies/*').map { |f| Movie.new(File.basename(f).sub(settings.library['dir_prefix'], '')) }
	haml :index, :layout => !request.xhr?
end

get '/movie/:id/generate' do
	Stalker.enqueue('movie.generate_previews', params.merge(:success => settings.callback['success'], :failure => settings.callback['failure']))
	redirect to "/movies"
end

get '/?' do
	redirect to '/movies'
end

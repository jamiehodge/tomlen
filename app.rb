#!/usr/bin/arch -arch i386 /usr/bin/ruby

$:.unshift File.expand_path('lib')
require 'movie'

require 'rubygems'
require 'bundler'
Bundler.require

configure do
	set :haml, { :format => :html5 }
end

get '/movies/new' do
	haml :new
end

get '/movies/:id' do
	@movie = Movie.new(params[:id])
	haml :show
end

delete '/movies/:id' do
	FileUtils.rm_rf File.join('public', 'movies', params[:id])
	redirect to '/movies'
end

get '/movies' do
	@movies = Dir.glob("public/movies/*").map { |f| Movie.new(File.basename(f)) }
	haml :index, :layout => !request.xhr?
end

post '/movies' do
	Stalker.enqueue(
		'movie.create', 
		{ 
			:tempfile => params[:file][:tempfile].path,
			:title => params[:title],
			:description => params[:description],
			:extension => File.extname(params[:file][:filename])
		})
	# movie = Movie.create(params[:file][:tempfile].path, :title => params[:title], :description => params[:description], :extension => File.extname(params[:file][:filename]) )
	redirect to "/movies"
end

get '/?' do
	redirect to '/movies'
end

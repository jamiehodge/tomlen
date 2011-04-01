#!/usr/bin/arch -arch i386 /usr/bin/ruby

$:.unshift '/usr/lib/podcastproducer'
require 'qt/qt'
require 'qt_extensions'
require 'yaml'

class Movie
	
	attr_reader :uuid
	
	NUMBER_OF_PREVIEWS = 10
	
	def initialize(uuid, &block)
		@uuid = uuid
		instance_eval &block if block_given?
	end
	
	def base_dir
		File.join 'public', 'movies', settings['library']['dir_prefix'] + uuid
	end
	
	def base_url
		File.join '/', 'movie', uuid
	end
	
	def thumbnails_dir
		File.join base_dir, settings['library']['thumbnail_dir']
	end
	
	def thumbnail_urls
		Dir.glob("#{thumbnails_dir}/*.png").collect { |f| File.join(base_url, 'thumbnail', File.basename(f, '.png')) }
	end
	
	def posterframes_dir
		File.join base_dir, settings['library']['posterframe_dir']
	end
	
	def posterframe_urls
		Dir.glob("#{posterframes_dir}/*.png").collect { |f| File.join(base_url, 'posterframe', File.basename(f, '.png')) }
	end
	
	def original
		Dir.glob(File.join base_dir, settings['library']['original_dir'], "#{uuid}.*").first
	end
	
	def original_url
		File.join base_url, 'original'
	end
	
	def duration
		info['duration'].to_f
	end
	
	def width
		info['width'].to_f
	end
	
	def height
		info['height'].to_f
	end
	
	def create_thumbnails(w=150)
		create_previews do |time,count|
			PcastQT.thumbnail(original, File.join(thumbnails_dir, '%.2d.png' % count), 'public.png', time, w, (w / width) * height)
		end
	end
	
	def create_posterframes
		create_previews do |time,count|
			PcastQT.posterimage(original, File.join(posterframes_dir, '%.2d.png' % count), 'public.png', time)
		end
	end
	
	private
	
	def settings
		YAML.load_file('settings.yml')
	end
	
	def info
		PcastQT.info(original)
	end
	
	def create_previews
		count = 0
		(0..duration).step(duration/(NUMBER_OF_PREVIEWS-1)) do |time|
			yield(time,count)
			count += 1
		end
	end
	
end
#!/usr/bin/arch -arch i386 /usr/bin/ruby

$:.unshift '/usr/lib/podcastproducer'
require 'qt/qt'
require 'yaml'

class Movie
	
	attr_reader :uuid
	
	NUMBER_OF_THUMBNAILS = 10
	
	def self.create(input, metadata={})
		self.new(`uuidgen`.strip) do
			create_directories
			save_original(input)
			save_metadata(metadata)
			create_thumbnails
		end
	end
	
	def initialize(uuid, &block)
		@uuid = uuid
		instance_eval &block if block_given?
	end
	
	def base_dir
		File.join 'public', 'movies', uuid
	end
	
	def base_url
		File.join '/', 'movies', uuid
	end
	
	def thumbnails_dir
		File.join base_dir, 'thumbnails'
	end
	
	def thumbnail_urls
		(0..(NUMBER_OF_THUMBNAILS-1)).map { |i| File.join(base_url, 'thumbnails', '%.2d.png' % i) }
	end
	
	def original
		File.join base_dir, "#{uuid}.mov"
	end
	
	def original_url
		File.join base_url, "#{uuid}.mov"
	end
	
	def duration
		@duration ||= PcastQT.info(original)['duration'].to_f
	end
	
	def title
		metadata[:title]
	end
	
	private
	
	def create_directories
		FileUtils.mkdir_p(thumbnails_dir)
	end
	
	def save_original(input)
		FileUtils.cp input, original
	end
	
	def save_metadata(metadata)
		File.open(File.join(base_dir, 'metadata.yml'), 'w') { |f| YAML.dump( metadata, f ) }
	end
	
	def metadata
		@metadata ||= YAML.load( File.open(File.join(base_dir, 'metadata.yml')) )
	end
	
	def create_thumbnails
		count = 0
		(0..duration).step(duration/(NUMBER_OF_THUMBNAILS-1)) do |time|
			PcastQT.posterimage(original, File.join(thumbnails_dir, '%.2d.png' % count), 'public.png', time)
			count += 1
		end
	end
	
end
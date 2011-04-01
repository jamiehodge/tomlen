#!/usr/bin/arch -arch i386 /usr/bin/ruby

$:.unshift '/usr/lib/podcastproducer'
require 'qt/qt'

class PcastQT
	
	def self.thumbnail(input, output, format="public.png", time=nil, width=120, height=90)
    input_movie = self.load_movie(input)
    return false unless input_movie
    if time
      time_interval = time
    else
      input_movie.gotoPosterTime
      succcess, time_interval = OSX.QTGetTimeInterval(input_movie.currentTime)
      if time_interval == 0
        success, time_interval = OSX.QTGetTimeInterval(input_movie.duration)
        time_interval /= 2.0
      end
    end
    poster_time = OSX.QTMakeTimeWithTimeInterval(time_interval)
    attributes = { 
			OSX::QTMovieFrameImageType => OSX::QTMovieFrameImageTypeCGImageRef,
			OSX::QTMovieFrameImageSize => OSX::NSValue.valueWithSize([width,height])
			}
    error = nil
    image, error = input_movie.frameImageAtTime_withAttributes_error(poster_time, attributes)
    if error != nil || image == nil
      log_error "could not get poster frame from movie"
      return false
    end
    if image.kind_of? OSX::ObjcPtr
      exec_args = [ "/usr/libexec/podcastproducer/qtposterimage", input, output, format ]
      exec_args << time if time
      return self.fork_exec_and_wait(*exec_args)
    end
    destination_types = OSX.CGImageDestinationCopyTypeIdentifiers()
    unless destination_types.include?(format)
      log_error "output format '#{format}' is invalid"
      log_warn "valid output formats: " + destination_types.to_ruby.inspect
      return false
    end
    destinationURL = OSX::NSURL.fileURLWithPath(output)
    destination = OSX.CGImageDestinationCreateWithURL(destinationURL, format, 1, nil)
    unless destination
      log_error "could not create the movie"
      return false
    end
    properties = { OSX::KCGImageDestinationLossyCompressionQuality => 0.75 }
    OSX::CGImageDestinationAddImage(destination, image, properties)
    success = OSX::CGImageDestinationFinalize(destination)
    unless success
      log_error "could not save the movie: #{error.localizedDescription}"
      return false
    end
    return success
  end

end
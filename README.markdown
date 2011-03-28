Tomlen
------

A simple Sinatra webapp to generate and display thumbnails from QuickTime movie files.

## Requirements

Tomlen leverages Apple's Podcast Producer middleware and is therefore OSX only.

## Installation

* Download and install [homebrew](https://github.com/mxcl/homebrew)
* Install git: `brew install git`
* Install tomlen: `git clone git://github.com/jamiehodge/tomlen.git`
* Install bundler: `sudo gem install bundler`
* Install gems: `cd tomlen`, `bundle install`
* Run tomlen: `arch -arch i386 rackup`
* Open browser: [http://localhost:9292](http://localhost:9292)

## TODO

Move thumbnails generation to a background task.

## License

The MIT License

Copyright (c) 2011 Copenhagen University

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
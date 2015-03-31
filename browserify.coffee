gulp        = require 'gulp'
browserify  = require 'browserify'
coffeeify   = require 'coffeeify'
source      = require 'vinyl-source-stream'
buffer      = require 'vinyl-buffer'
path        = require 'path'
rename      = require 'gulp-rename'
uglify      = require 'gulp-uglify'
size        = require 'gulp-size'
sourcemaps  = require 'gulp-sourcemaps'

defaults =
  entry       : 'scripts/index.coffee'
  sources     : no # Use glob to require all matching modules into bundle
  inject      : {} # Objects to be injected into bundle. Will be exposed as keys
  debug       : no
  destination : 'build/assets/'

module.exports = (options = {}) ->
  options[key] ?= value for key, value of defaults

  ->
    browserify debug: yes # options.debug
      .add path.resolve process.cwd(), options.entry
      .transform coffeeify
      # TODO: require scripts
      # TODO: inject objects
      # Probably the easiest way is to do it async and pipe bundle in callback
      .bundle()
      # TODO: source maps doesn't work so well
      .pipe source path.basename options.entry
      .pipe rename extname: '.js'
      .pipe buffer()
      .pipe sourcemaps.init loadMaps: yes
      .pipe size title: 'before'
      .pipe uglify()
      .pipe size title: 'after'
      .pipe sourcemaps.write './'
      .pipe gulp.dest options.destination

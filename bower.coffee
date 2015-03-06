gulp      = require 'gulp'
bower     = require 'gulp-bower'

# Read options from assets
# Is this a good idea?
# Probably this task wont be used without assets anyway.
options   = require './assets',

module.exports = options

gulp.task 'bower', ->
  bower()
    .pipe gulp.dest options.destination

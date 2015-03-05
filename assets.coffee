gulp      = require 'gulp'
bower     = require 'gulp-bower'

defaults  = require './defaults'

options = defaults 'assets',
  sources     : 'assets/**/*'
  destination : 'build/public/'

module.exports = options

gulp.task 'bower', ->
  bower()
    .pipe gulp.dest options.destination

gulp.task 'assets', ['bower'], ->
  gulp
    .src  options.sources
    .pipe gulp.dest options.destination

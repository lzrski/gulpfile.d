gulp      = require 'gulp'

defaults  = require './defaults'

options = defaults 'assets',
  sources     : 'assets/**/*'
  destination : 'build/public/'

module.exports = options

gulp.task 'assets', ->
  gulp
    .src  options.sources
    .pipe gulp.dest options.destination

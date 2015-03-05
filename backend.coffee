gulp      = require 'gulp'

srcmaps   = require 'gulp-sourcemaps'
coffee    = require 'gulp-coffee'
defaults  = require './defaults'

options = defaults 'backend',
  sources     : 'backend/**/*'
  destination : 'build/'

module.exports = options

gulp.task 'backend', ->
  gulp
    .src options.sources
    .pipe srcmaps.init()
    .pipe coffee()
    .pipe srcmaps.write()
    .pipe gulp.dest options.destination

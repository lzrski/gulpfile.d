gulp      = require 'gulp'

srcmaps   = require 'gulp-sourcemaps'
coffee    = require 'gulp-coffee'
defaults  = require './defaults'

options   = defaults 'scripts',
  sources     : 'scripts/**/*'
  destination : 'build/public/'

module.exports = options

gulp.task 'scripts', ->
  gulp
    .src options.sources
    .pipe srcmaps.init()
    .pipe coffee()
    .pipe srcmaps.write 'maps/' # TODO: use options?
    .pipe gulp.dest options.destination

gulp      = require 'gulp'
stylus    = require 'gulp-stylus'
defaults  = require './defaults'

options = defaults 'stylus',
  entry       : 'styles/main.styl'
  sources     : 'styles/**/*.styl'
  destination : 'build/public/'

module.exports = options

gulp.task 'stylus', ->
  gulp
    .src  options.entry
    .pipe stylus errors: yes
    .pipe gulp.dest options.destination

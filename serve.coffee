gulp      = require 'gulp'
{log}     = require 'gulp-util'
run       = require 'run-sequence'
webserver = require 'gulp-webserver'
defaults  = require './defaults'

# Try to read paths from parent module (main gulp file)
options = defaults 'serve',
  root  : 'build/'

gulp.task 'serve', ->
  gulp
    .src options.root
    .pipe webserver livereload: yes, open: yes

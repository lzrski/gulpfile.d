gulp    = require 'gulp'
bower   = require 'gulp-bower'
_       = require 'lodash'

# Try to read paths from parent module (main gulp file)
options = _.defaults module.parent?.exports?.assets,
  sources     : 'assets/**/*'
  destination : 'build/public/'

gulp.task 'bower', ->
  bower()
    .pipe gulp.dest options.destination

gulp.task 'assets', ['bower'], ->
  gulp
    .src  options.sources
    .pipe gulp.dest options.destination

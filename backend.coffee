gulp    = require 'gulp'

srcmaps = require 'gulp-sourcemaps'
coffee  = require 'gulp-coffee'
_       = require 'lodash'

# Try to read paths from parent module (main gulp file)
options = _.defaults module.parent?.exports?.backend or {},
  sources     : 'backend/**/*'
  destination : 'build/'

gulp.task 'backend', ->
  gulp
    .src options.sources
    .pipe srcmaps.init()
    .pipe coffee()
    .pipe srcmaps.write()
    .pipe gulp.dest options.destination

gulp    = require 'gulp'

srcmaps = require 'gulp-sourcemaps'
coffee  = require 'gulp-coffee'
_       = require 'lodash'

# Try to read paths from parent module (main gulp file)
options = _.defaults module.parent?.exports?.scripts,
  sources     : 'scripts/**/*'
  destination : 'build/public/'

gulp.task 'scripts', ->
  gulp
    .src options.sources
    .pipe srcmaps.init()
    .pipe coffee()
    .pipe srcmaps.write 'maps/' # TODO: use options?
    .pipe gulp.dest options.destination

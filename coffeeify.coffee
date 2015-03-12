gulp        = require 'gulp'

coffeeify   = require 'coffeeify'
browserify  = require 'gulp-browserify'
through     = require 'through2'
rename      = require "gulp-rename"
path        = require 'path'
{log}       = require 'gulp-util'
notify      = require 'gulp-notify' # TODO: move notification logic to main gulpfile

defaults    = require './defaults'

options = defaults 'coffeeify',
  entry       : 'scripts/index'
  sources     : 'scripts/**/*'
  destination : 'build/public/application.js'

module.exports = options

scripts = [] # Hold all scripts' paths here
gulp.task 'scan-scripts', ->
  # Set options.sources to false to avoid scaning and requiring all scripts
  return unless options.sources

  log 'Scanning'
  gulp
    .src options.sources, read: no
    .pipe rename (name) ->
      scripts.push path.relative '.', name.dirname + '/' + name.basename
      name

gulp.task 'coffeeify', ['scan-scripts'], ->
  gulp
    .src options.entry, read: no
    .pipe browserify
      transform : ['coffeeify']
      extensions: ['.coffee']
      debug     : yes # TODO: conditional
    .on 'prebundle', (bundle) ->
      # Add all the modules, even if they are not explicitly required.
      # This allows to require modules procedurally, e.g. in a loop, like that:
      #
      #   require "./#{mod}" for mod in ['a', 'b', 'c']
      #
      # You can turn this feature off by setting sources option to false

      log 'Requiring', scripts
      for script in scripts
        # Expose index scripts as their dirnames
        # to mimic node's package name resolution mechanism
        if (path.basename script) is 'index'
          expose = path.dirname script
        else
          expose = script

        bundle.require './' + script, {expose}
    .on 'error', notify.onError (error) ->
      console.error error.message
      console.error error.stack
      "Error building scripts: #{error.message}"
    .pipe rename    path.basename options.destination
    .pipe gulp.dest path.dirname  options.destination
    .pipe notify "Done building"

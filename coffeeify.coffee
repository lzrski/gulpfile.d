gulp        = require 'gulp'

coffeeify   = require 'coffeeify'
browserify  = require 'gulp-browserify'
through     = require 'through2'
rename      = require "gulp-rename"
path        = require 'path'
{log}       = require 'gulp-util'
notify      = require 'gulp-notify' # TODO: move notification logic to main gulpfile

defaults    = require './defaults'

log 'The gulpfile.d/coffeeify module is depreciated. Please used browserify instead.'

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

      for script in scripts
        # Expose index scripts as their dirnames
        # to mimic node's package name resolution mechanism
        if (path.basename script) is 'index'
          expose = path.dirname script
        else
          expose = script

        bundle.require './' + script, {expose}

      if options.config
        # Generate config object and inject it into bundle
        config  = require 'config-object'
        temp    = require 'temp'
        fs      = require 'fs'

        # TODO: Make config files paths configurable via settings
        config.load '../defaults.cson', required: yes
        config.load '../package.json', required: yes, at: '/package'
        config.load '../config.cson'

        exposed = config.clone keys: config.expose
        json = JSON.stringify do exposed.get

        file = temp.openSync 'config'
        fs.writeSync file.fd, "module.exports = #{json}"
        fs.closeSync file.fd
        bundle.require file.path, expose: 'config'

    .on 'error', notify.onError (error) ->
      console.error error.message
      console.error error.stack
      "Error building scripts: #{error.message}"
    .pipe rename    path.basename options.destination
    .pipe gulp.dest path.dirname  options.destination
    .pipe notify "Done building"

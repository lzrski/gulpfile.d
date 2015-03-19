# This is probably too complicated and project specific to generalize.

gulp      = require 'gulp'
_         = require 'lodash'
cp        = require 'child_process'
{log}     = require 'gulp-util'
run       = require 'run-sequence'
defaults  = require './defaults'

# Try to read paths from parent module (main gulp file)
settings = module.parent?.exports or {}
backend = require './backend' # task module should export it's options

server = null
gulp.task 'serve', ->
  if server
    log 'Restarting server'
    do server.kill
    server = null

  server = cp.fork backend.main

# Watch
gulp.task 'develop', (done) ->

  run 'build', 'serve', (done) ->

    for task of settings when task isnt 'develop'
      options = require "./#{task}"
      log "Watching #{options.sources} for #{task}"
      gulp.watch options.sources, [task]

    log "Watching #{backend.main} for serve"
    gulp.watch backend.main, ['serve']

    # No risk here.
    # If there is no bower.json file, then it will never fire.
    # Huh?
    log "Watching bower.json for bower"
    gulp.watch 'bower.json', ['bower']

  process.on 'exit', ->
    # Make sure logs look nice :)
    console.log ''
    do done
    do process.exit

process.on 'exit', ->
  if server
    console.log ''
    log 'Killing server'
    do server.kill
    server = null

# Is this safe?
process.on event, process.exit for event in [
  'SIGINT'
  'uncoughtException'
]

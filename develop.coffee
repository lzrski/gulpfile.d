gulp    = require 'gulp'
_       = require 'lodash'
cp      = require 'child_process'
{log}   = require 'gulp-util'
run     = require 'run-sequence'

# Try to read paths from parent module (main gulp file)
settings = module.parent?.exports or {}

server = null
gulp.task 'serve', ->
  options = _.defaults settings.backend or {},
    sources     : 'backend/**/*'
    main        : 'build/app.js' # TODO: read it from package.json

  if server
    log 'Restarting server'
    do server.kill
    server = null

  server = cp.fork options.main

# Watch
gulp.task 'develop', (done) ->

  run 'build', 'serve', (done) ->

    for task, options of settings when task isnt 'develop'
      log "Watching #{options.sources} for #{task}"
      gulp.watch options.sources, [task]

    log "Watching #{settings.backend.main} for serve"
    gulp.watch settings.backend.main, ['serve']

    log "Watching bower.json for bower"
    gulp.watch 'bower.json', ['bower']

  process.on 'exit', ->
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

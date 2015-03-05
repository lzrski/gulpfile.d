# Try to read settings from parent module (main gulp file)
{log}     = require 'gulp-util'
_         = require 'lodash'

module.exports = (task, defaults) ->
  # You can provide only defaults (no task)
  # in which case whole settings object will be used
  if not defaults and typeof task is 'object'
    defaults = task
    task = undefined

  log "Loading settings for #{task or '*'}"
  
  parent = module
    .parent
    ?.parent
    ?.exports
  parent ?= {}

  settings = if task then parent[task] else parent

  return _.defaults settings, defaults

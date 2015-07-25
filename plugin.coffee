

fs = require 'fs'
fm = require 'front-matter'
jade = require 'jade'
_ = require 'lodash'

module.exports = (env, callback) ->
  class JadePage extends env.plugins.Page
    constructor: (@filepath, @rendered, @metadata) ->

    getLocation: (base) ->
      uri = @getUrl base
      return uri[0..uri.lastIndexOf('/')]

    getHtml: (base=env.config.baseUrl) ->
      @rendered

  JadePage.fromFile = (filepath, callback) ->
    config = env.config.jade or {}
    config.filename = filepath.full
    locals = {}
    fs.readFile filepath.full, (error, result) ->
      unless error
        try
          content = fm(result.toString())
          _.extend locals, content.attributes
          rendered = jade.compile(content.body, config)(locals)
          console.log rendered
          plugin = new JadePage filepath, rendered, content.attributes
          callback null, plugin
        catch error
          callback error

  env.registerContentPlugin 'text', '**/*.*(jade)', JadePage

  callback()

async = require 'async'
jade = require 'jade'
fs = require 'fs'
path = require 'path'
url = require 'url'

module.exports = (env, callback) ->
	class JadePage extends env.plugins.Page

    constructor: (@filepath, @metadata, @markdown) ->
      console.log "JadePage"

    getLocation: (base) ->
      uri = @getUrl base
      return uri[0..uri.lastIndexOf('/')]

    getHtml: (base=env.config.baseUrl) ->
      ### parse @markdown and return html. also resolves any relative urls to absolute ones ###
      # options = env.config.markdown or {}
      # return parseMarkdownSync this, @markdown, @getLocation(base), options

      # try
      #   callback null, new Buffer @fn(locals)
      # catch error
      #   callback error
      return "<h1>JADE CONTENT</h1>"

  JadePage.fromFile = (filepath, callback) ->
    async.waterfall [
      (callback) ->
        fs.readFile filepath.full, callback
        new Buffer(".fake")
      (buffer, callback) =>
        conf = env.config.jade or {}
        conf.filename = filepath.full
        try
          rv = jade.compile buffer.toString(), conf
          callback null, new this rv
        catch error
          callback error
    ], callback

  env.registerContentPlugin 'pages', '**/*.jade', JadePage
  callback()

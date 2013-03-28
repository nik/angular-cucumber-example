Browser     = require 'zombie'
{ Factory } = require 'forgery'
Hem         = require 'hem'
nock        = require 'nock'
selectors   = require './selectors'
should      = require 'should'
selectors   = require './selectors'

# Require the factories
require '../../spec/factories'

# Hem options
hemOptions      = require '../../slug.json'
hemOptions.port = process.env.PORT || 9296

# Start the Hem Server
new Hem(hemOptions).server()

# Zombie options
Browser.site = "http://localhost:#{ hemOptions.port }/"
Browser.debug = true if process.env.DEBUG == 'true'

class World
  constructor: (callback) ->
    @browser   = new Browser()
    @nock      = nock(Browser.site, { allowUnmocked: true })
                 #.log(console.log)

    nock('http://copycopter.example.com')
      .persist()
      .filteringPath(/translations.+/g, 'translations')
      .get('/translations')
      .reply(200, (path) -> "#{path.match(/callback=(.+)/)[1]}({ 'en': { } })")
      #.log(console.log)

    callback(@)

  visit: (url, next) ->
    @browser.visit url, (err, browser, status) =>
      throw err if err
      browser.wait (err) =>
        throw err if err
        @$ = @jQuery = browser.window.$
        next err, browser, status

  selectorFor: (locator) ->
    for regexp, path of selectors
      regexp = new RegExp(regexp)

      scope = ''
      if match = locator.match(regexp)
        if typeof path == 'string'
          scope = path
        else
          scope = path.apply @, match.slice(1)
        return scope

    throw new Error("Could not find path for '#{locator}'")

  Factory: (factoryName, options) ->
    for key, value of options
      if value == 'true'
        options[key] = true
      else if value == 'false'
        options[key] = false
      else if value == 'null'
        options[key] = null

    Factory factoryName, options

module.exports.World = World

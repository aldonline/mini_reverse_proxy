_            = require 'underscore'
querystring  = require 'querystring'
url_module   = require 'url'
http_module  = require 'http'
https_module = require 'https'

###
Sets up a proxy in /proxy.
Usage: GET|POST|PUT|etc http://host/proxy?url=TARGET_URL
TARGET_URL can be http or https
To prevent abuse we have hardcoded a whitelist ( see below )

example:
$ curl -X GET http://localhost:3001/proxy?url=http://foo.com/api/v2/magazine/summary.json

This can be used by the Ajax client to achieve CORS

###

module.exports = setup_proxy = ( {app, whitelist, mount} ) ->
  
  mount ?= '/proxy'

  host_is_allowed = ( host ) -> if whiltelist? then host in whitelist else yes

  app.all mount, ( req, res ) ->
    url    = req.query.url

    parsed = url_module.parse url
    ###
    parsed = { protocol: 'http:',
      slashes: true,
      host: 'foo.com',
      hostname: 'foo.com',
      href: 'http://foo.com/a/b?x=y',
      search: '?x=y',
      query: 'x=y',
      pathname: '/a/b',
      path: '/a/b?x=y' }
    ###

    if not host_is_allowed parsed.host
      return res.send 404, 'Host ' + parsed.host + ' not allowed'

    parsed.method  = req.method
    parsed.headers = _.extend req.headers, { host: parsed.hostname }
    parsed.url     = url

    http_ = switch parsed.protocol
      when 'http:' then http_module
      when 'https:' then https_module

    proxy_request = http_.request parsed, (pres) ->
      pres.pipe     res
      res.writeHead pres.statusCode, pres.headers
    
    req.pipe proxy_request



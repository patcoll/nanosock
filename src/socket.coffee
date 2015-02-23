_ = require 'underscore'
Events = require 'ampersand-events'

NanoSock = (options) ->
  unless @ instanceof NanoSock
    return new NanoSock options
  @options = _.extend({}, _.result(@, 'options'), options)
  @initialize.apply(@, arguments)

# Small wrapper around WebSocket to help implement nanomsg protocols (scalable
# protocols, or SP).
#
# Usage:
#
#   sock = NanoSock({url: "ws://sp.endpoint.org:3333", protocol: "sub"})
#
# Listen for key events:
#
#   sock.on('open', function() { console.log('socket opened'); });
#   sock.on('send', function(msg) { console.log('message sent: ', msg); });
#   sock.on('message', function(e) { console.log('message recv: ', e.data); });
#   sock.on('close', function() { console.log('socket closed'); });
#
_.extend(NanoSock.prototype, Events,
  newSocket: ->
    new WebSocket @options.url, "#{@options.protocol}.sp.nanomsg.org"
  send: (msg) ->
    @socket.send.apply(@socket, arguments)
    @trigger 'send', msg
  close: ->
    @socket.close.apply(@socket, arguments)
  options:
    url: null
    protocol: null
    # TODO: add reconnect
    reconnect: false
  initialize: (options) ->
    unless WebSocket
      throw new Error "no WebSocket! please use a browser that has WebSocket support."

    unless @options.url?
      throw new Error "no url! please provide a url."

    unless @options.protocol?
      throw new Error "no protocol! please provide a protocol."

    @socket = @newSocket()

    _.each [
      'open'
      'close'
      'message'
      'error'
    ], (name) =>
      eventName = "on#{name}"
      @socket[eventName] = =>
        if name in ['message', 'error']
          @trigger name, arguments[0]
        else
          @trigger name

    # event handlers

    # convenience to close socket on reload or when browsing away from page.
    window?.addEventListener?('beforeunload', => @socket.close())
)

module.exports = NanoSock

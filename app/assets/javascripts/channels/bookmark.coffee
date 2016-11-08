App.bookmark = App.cable.subscriptions.create "BookmarkChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log('channel connected')

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log('channel disconnected')

  received: (data) ->
    console.log('channel data receivied')
    console.log(data)
    # Called when there's incoming data on the websocket for this channel

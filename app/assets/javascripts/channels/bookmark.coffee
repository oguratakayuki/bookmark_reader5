App.bookmark = App.cable.subscriptions.create "BookmarkChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log('channel connected')

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log('channel disconnected')

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log('channel data receivied')
    console.log(data)
    toastr.success('importが完了しました')

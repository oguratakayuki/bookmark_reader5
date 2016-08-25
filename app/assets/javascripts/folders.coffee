# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  $('li.folderss').click (e) ->
    $.each $(@).data('child-ids'), (index, child_id) =>
      console.log(child_id)

 

    #console.log($(element).data('child-ids'))
    #console.log($(element).data('id'))

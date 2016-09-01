# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  $('li.folders').click (e) ->
    $.each $(@).data('child-ids'), (index, child_id) =>
      console.log(child_id)

  $('li.folders span').click (e) ->
    console.log('hgeo')
    $(@).parents('div').siblings().fadeToggle(400, "linear")
 

    #console.log($(element).data('child-ids'))
    #console.log($(element).data('id'))

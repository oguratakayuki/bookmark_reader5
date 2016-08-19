# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  $('li').each (index, element) =>
    #console.log($(element).data('child-ids'))
    console.log($(element).data('id'))

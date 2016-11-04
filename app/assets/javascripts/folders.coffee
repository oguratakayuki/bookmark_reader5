# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  $('#bookmark-import').click (e) ->
    $('.modal').modal('show')

  $('li.folders').click (e) ->
    $.each $(@).data('child-ids'), (index, child_id) =>
      console.log(child_id)

  $('li.folders span').click (e) ->
    console.log('hgeo')
    $(@).parents('div').siblings().fadeToggle(400, "linear")
 
  # $('.horizontal-scroll-bar-module').click (e) ->
  $(document).on 'click', '.horizontal-scroll-bar-module', ->
    console.log('hgeo')
    url = $(@).data('href')
    target = $(@)
    $.ajax(url: url).done (html) ->
      $('#results').append(html)
      console.log target
      console.log target.closest('div.layer').data('layer')
      console.log 'hoge'
      console.log target.closest('div.layer').children('div.bookmarks')
      target.closest('div.layer').children('div.bookmarks').toggle('slow')
    #console.log($(element).data('child-ids'))
    #console.log($(element).data('id'))

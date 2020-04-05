# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  ShowShortHelp = (help_item_id) ->
    if $("#"+help_item_id).is(":hidden")
      $("#"+help_item_id).show('slow')
    else
      $("#"+help_item_id).hide('slow')
    return false  

  window.ShowShortHelp = ShowShortHelp

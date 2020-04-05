# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  selects_update = () ->
    $('#help_topic_parent_id').select2 theme: 'bootstrap'


  parent_change = () ->
    if document.getElementById('help_topic_parent_id')
      p_id = $("#help_topic_parent_id").val()
      p_id = "0" if p_id == "" || p_id is null
      $.ajax 'update_neighbours',
        type: 'GET'
        dataType: 'script'
        data: {
          help_t_id: p_id
        } 	 

	
  window.parent_change = parent_change 
  $(document).on 'page:load', selects_update
  $(document).on 'turbolinks:load', selects_update	
  $(document).on 'page:load', parent_change 
  $(document).on 'turbolinks:load', parent_change 
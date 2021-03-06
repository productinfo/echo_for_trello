# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  weeklyOptions = { 'weekly': [
    { 'value': 0, 'name': 'Sunday' },
    { 'value': 1, 'name': 'Monday' },
    { 'value': 2, 'name': 'Tuesday' },
    { 'value': 3, 'name': 'Wednesday' },
    { 'value': 4, 'name': 'Thursday' },
    { 'value': 5, 'name': 'Friday' },
    { 'value': 6, 'name': 'Saturday' } ]
  }

  monthlyOptions = { 'monthly': [] }
  for day in [1..31]
    monthlyOptions['monthly'].push({ 'day': day })

  clearModalInfo = ->
    $('#new_list_modal_messages').removeClass()
    $('#new_list_modal_messages').text('')

  $('#card_trello_list_id').on 'change', ->
    if this.value == 'new_list'
      $('#new_list_modal').modal('show')

  $('#new_list_modal').on 'hide.bs.modal', (e)->
    $('#card_trello_list_id').val('')
    clearModalInfo()
    $('#new_list_modal_title').val('')

  $('#new_list_modal_save').on 'click',(e)->
    clearModalInfo()

    boardId = $('#card_trello_board_id').val()
    listName = $('#new_list_modal_title').val()
    if listName == ''
      $('#new_list_modal_messages').addClass('bg-danger')
      $('#new_list_modal_messages').text('The field is blank!')
    else
      $('#new_list_modal_loader').removeClass('hidden')
      $.ajax
        url: '/boards/' + boardId + '/new_list'
        type: 'POST'
        dataType: 'json'
        data: { 'id': boardId, 'list_name': listName }
        error: (jqXHR, textStatus, errorThrown) ->
          $('#new_list_modal_loader').addClass('hidden')
          $('#new_list_modal_messages').addClass('bg-danger')
          $('#new_list_modal_messages').text(jqXHR.responseJSON.message)
        success: (data, textStatus, jqXHR) ->
          $('<option value="' + data.list_id + '">' + listName + '</option>').insertBefore($('#card_trello_list_id option[value="new_list"]'))
          $('#new_list_modal_loader').addClass('hidden')
          $('#new_list_modal').modal('hide')
          $('#card_trello_list_id').val(data.list_id)

  $('.card-form').validate
    rules:
      'card[trello_list_id]':
        required: true
      'card[title]':
        required: true
      'card[frequency]':
        required: true
    messages:
      'card[trello_list_id]': 'Please select a list from the menu, or create a new list'
      'card[title]': 'Please enter the card title'
      'card[frequency]': 'Please select the frequency you want the card to be created'
    highlight: (elem) ->
      $(elem).parent('div').addClass('has-error')
    unhighlight: (elem) ->
      $(elem).parent('div').removeClass('has-error')

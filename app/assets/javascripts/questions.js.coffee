$(document).on 'ready turbolinks:load', ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    questionId = $(this).data('questionId')
    $('form#edit-question-' + questionId).removeClass 'hidden'

App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    console.log 'Connected to channel Questions'
    @perform 'follow'
  ,
  received: (new_question) ->
    $('.questions').append new_question
    $('.notice').fadeIn 'slow', ->
      $('.notice').addClass 'alert-success'
      $('.notice').html 'New question was just added!'
      $('.notice').delay(3000).fadeOut()
})
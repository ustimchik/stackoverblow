$(document).on 'ready turbolinks:load', ->
  $('.answers, .answer-best').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass 'hidden'

App.cable.subscriptions.create('AnswersChannel', {
  connected: ->
    questionId = gon.question_id
    if questionId
      console.log 'Connected to channel Answers'
      @perform 'follow', question_id: questionId
  ,
  received: (data) ->
    if gon.current_user_id != data.data.user_id
      $('.answers').append JST['templates/answer'](data)
})
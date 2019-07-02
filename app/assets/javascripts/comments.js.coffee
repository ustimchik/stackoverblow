$(document).on 'ready turbolinks:load', ->
  $('.comments').on 'click', '.edit-comment-link', (e) ->
    e.preventDefault()
    $(this).hide()
    commentId = $(this).data('commentId')
    $('form#edit-comment-' + commentId).removeClass 'hidden'

ActionCable.createConsumer().subscriptions.create('CommentsChannel', {
  connected: ->
    questionId = gon.question_id
    if questionId
      console.log 'Connected to channel Comments'
      @perform 'follow', question_id: questionId
  ,
  received: (data) ->
    if gon.current_user_id != data.data.user_id
      if data.data.commentable_type.toLowerCase() == 'question'
        commentable_css = '.question'
      else
        commentable_css = "#answer-#{data.data.commentable_id}"
      $("#{commentable_css}").find('.comments').append JST['templates/comment'](data)
})
$(document).on('turbolinks:load',function() {
    $('.question').on('click', '.edit-question-link', function(e){
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });


    $('.qvotebuttons').on('click', '.upvote', function (e) {
        e.preventDefault();
        var questionId = $(this).data('questionId');
        $.ajax({
            url: '/questions/' + questionId + '/upvote',
            type: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': Rails.csrfToken()
            },
            credentials: 'same-origin'
        })
        .then(function(response){
            $('.question').find('.qvotebuttons').children('.downvote').removeClass('on');
            $('.question').find('.qvotebuttons').children('.upvote').addClass('on');
            $('.question').find('.votescore').text("Votes: " + response.score);
            $('.question-errors').html(response.notice);

        })
    });

    $('.qvotebuttons').on('click', '.clearvote', function (e) {
        e.preventDefault();
        var questionId = $(this).data('questionId');
        $.ajax({
            url: '/questions/' + questionId + '/clearvote',
            type: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': Rails.csrfToken()
            },
            credentials: 'same-origin'
        })
            .then(function(response){
                $('.question').find('.votescore').text("Votes: " + response.score);
                $('.question').find('.qvotebuttons').children().removeClass('on');
                $('.question-errors').html(response.notice);
            })
    });

    $('.qvotebuttons').on('click', '.downvote', function (e) {
        e.preventDefault();
        var questionId = $(this).data('questionId');
        $.ajax({
            url: '/questions/' + questionId + '/downvote',
            type: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': Rails.csrfToken()
            },
            credentials: 'same-origin'
        })
            .then(function(response){
                $('.question').find('.qvotebuttons').children('.upvote').removeClass('on');
                $('.question').find('.qvotebuttons').children('.downvote').addClass('on');
                $('.question').find('.votescore').text("Votes: " + response.score);
                $('.question-errors').html(response.notice);
            })
    });
});
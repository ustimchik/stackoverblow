$(document).on('turbolinks:load',function() {
    $('.answers, .answer-best').on('click', '.edit-answer-link', function(e){
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('.avotebuttons').on('click', '.upvote', function (e) {
        e.preventDefault();
        var answerId = $(this).data('answerId');
        $.ajax({
            url: '/answers/' + answerId + '/upvote',
            type: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': Rails.csrfToken()
            },
            credentials: 'same-origin'
        })
            .then(function(response){
                console.log(answerId);
                $('#answer-' + answerId).find('.avotebuttons').children('.downvote').removeClass('on');
                $('#answer-' + answerId).find('.avotebuttons').children('.upvote').addClass('on');
                $('#answer-' + answerId).find('.votescore').text("Votes: " + response.score);
                $('.answer-errors').html(response.notice);
            })
    });

    $('.avotebuttons').on('click', '.clearvote', function (e) {
        e.preventDefault();
        var answerId = $(this).data('answerId');
        $.ajax({
            url: '/answers/' + answerId + '/clearvote',
            type: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': Rails.csrfToken()
            },
            credentials: 'same-origin'
        })
            .then(function(response){
                console.log(answerId);
                $('#answer-' + answerId).find('.avotebuttons').children().removeClass('on');
                $('#answer-' + answerId).find('.votescore').text("Votes: " + response.score);
                $('.answer-errors').html(response.notice);
            })
    });

    $('.avotebuttons').on('click', '.downvote', function (e) {
        e.preventDefault();
        var answerId = $(this).data('answerId');
        $.ajax({
            url: '/answers/' + answerId + '/downvote',
            type: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': Rails.csrfToken()
            },
            credentials: 'same-origin'
        })
            .then(function(response){
                console.log(answerId);
                $('#answer-' + answerId).find('.avotebuttons').children('.upvote').removeClass('on');
                $('#answer-' + answerId).find('.avotebuttons').children('.downvote').addClass('on');
                $('#answer-' + answerId).find('.votescore').text("Votes: " + response.score);
                $('.answer-errors').html(response.notice);
            })
    });
});
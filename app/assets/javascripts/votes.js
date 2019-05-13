$(document).on('ready turbolinks:load',function() {
    $('.votebuttons').on('click', '.upvote', function () {
        $(this).on('ajax:success', function(event){
            var response = event.detail[0];
            $(this).closest('.votebuttons').children('.downvote').removeClass('on');
            $(this).closest('.votebuttons').children('.upvote').addClass('on');
            $(this).closest('.votebuttons').siblings('.votescore').text("Votes: " + response.score);
            $('.notice').html(response.notice).addClass('alert-success');
        })
    })

    .on('click', '.clearvote', function () {
        $(this).on('ajax:success', function(event){
            var response = event.detail[0];
            $(this).closest('.votebuttons').siblings('.votescore').text("Votes: " + response.score);
            $(this).closest('.votebuttons').children().removeClass('on');
            $('.notice').html(response.notice).addClass('alert-success');
        })
    })

    .on('click', '.downvote', function () {
        $(this).on('ajax:success', function(event){
            var response = event.detail[0];
            $(this).closest('.votebuttons').children('.upvote').removeClass('on');
            $(this).closest('.votebuttons').children('.downvote').addClass('on');
            $(this).closest('.votebuttons').siblings('.votescore').text("Votes: " + response.score);
            $('.notice').html(response.notice).addClass('alert-success');
        })
    })
});
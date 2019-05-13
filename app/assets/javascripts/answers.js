$(document).on('ready turbolinks:load',function() {
    $('.answers, .answer-best').on('click', '.edit-answer-link', function(e){
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });
});
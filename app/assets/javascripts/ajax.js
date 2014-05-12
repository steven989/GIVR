$('document').ready(function(){

    $('.profile_view_button').on('click',function(){

        event.preventDefault();
    

        $.ajax({
            url: $(this).attr('href'),
            type: 'GET',
            dataType: 'script',
            data: { view: $(this).data('view')}
        });

    });

})
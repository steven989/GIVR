// document ready
$(function(){
    landingPageForm();
});

// landing page mail subscribe form validation
var a;

function landingPageForm() {
    $('.subscription_form').on('input change',function(){
        if (
            !($('#email').val().match(/@[a-zA-Z_]+?\.[a-zA-Z]{2,12}$/) == null)
            &&
            ($('#role_professional').prop('checked') || $('#role_npo').prop('checked') || $('#role_business').prop('checked') || $('#role_other').prop('checked'))
        ) {
            $('.subscribe').removeClass('disabled');
            $(this).parent().find('.hidden').removeClass('hidden');
            if ($('#role_professional').prop('checked')) {
                $(this).parent().find('.category_input label').html('My skills');
            } else if ($('#role_npo').prop('checked')) {
                $(this).parent().find('.category_input label').html("Projects we'd like help with");
            } else {
                $(this).parent().find('.category_input').addClass('hidden');
            }

        } else { 
            $('.subscribe').addClass('disabled')
        };  
    });
 
}

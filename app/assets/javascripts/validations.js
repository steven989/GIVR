// document ready
$(function(){
    landingPageForm();
});

// landing page mail subscribe form validation

function landingPageForm() {
    $('.subscription_form').on('input change',function(){
        if (
            !($('#email').val().match(/@[a-zA-Z_]+?\.[a-zA-Z]{2,12}$/) == null)
            &&
            ($('#role_professional').prop('checked') || $('#role_npo').prop('checked') || $('#role_business').prop('checked') || $('#role_other').prop('checked'))
        ) {$('.subscribe').removeClass('disabled')} else { 
            $('.subscribe').addClass('disabled')
        };  
    });
 
}

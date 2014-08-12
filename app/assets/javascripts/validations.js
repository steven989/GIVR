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

// General function to validate the presence of fields

function generalFromValidationForPresence() {
    var emptyArray = []
    $(this).closest('form').find('.required_field').each(function(){
        if ($(this).val() == "") {
            $(this).css({
                "background-color":"#F1D7D7"
            });
            emptyArray.push($(this));
        } else {
            $(this).css({
                "background-color":"none"
            });        
        };
    });
    if (typeof(error_declaration_variable) == 'undefined') {
        if (emptyArray.length > 0) {
            $(this).closest('form').find('.missing_field_error').html('<p>Ensure all the required fields above are filled in.</p>');
            $(this).closest('form').find('.missing_field_error').removeClass('hidden');
            return 'missing'
        } else {
            $(this).closest('form').find('.missing_field_error').html('');
            $(this).closest('form').find('.missing_field_error').addClass('hidden');
            return 'okay'
        }
    } else {
        return 'missing'
    }
}



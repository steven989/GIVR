

$(window).ready(

    $(document).on('scroll', scrollCheck)

    );


function scrollCheck() {

    var scrollPosition = window.scrollY

    var threshold = $('#who_are_we').outerHeight(false) // the threshold is set to the height of the #who_are_we div because when we scroll past the bottom of this div we want to trigger the header shrinking

    var transitionLength = 200;

    if (scrollPosition > threshold) { 
        // $('#moving_piece').animate({height: "4rem"},transitionLength)
        $('#moving_piece').fadeOut(transitionLength)
    }
    else 
        {  
            // $('#moving_piece').animate({height: "6rem"},transitionLength)
            $('#moving_piece').fadeIn(); 

    }    
}


function shrinkHeader(transitionLength) {

    $('#moving_piece').animate({height: "4rem"},transitionLength)
    $('#moving_piece').fadeOut(transitionLength)

}

function growHeader(transitionLength) {

    // $('#moving_piece').animate({height: "6rem"},transitionLength)
    $('#moving_piece').fadeIn(transitionLength)

}